//
//  HistoryService.swift
//  CutBox
//
//  Created by Jason Milkins on 24/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import SwiftyStringScore
import RxSwift

protocol PasteboardWrapperType {
    var pasteboardItems: [NSPasteboardItem]? { get }
}

class PasteboardWrapper: PasteboardWrapperType {
    var pasteboardItems: [NSPasteboardItem]? {
        return NSPasteboard.general.pasteboardItems
    }
}

class HistoryService: NSObject {

    static let shared = HistoryService()

    var _historyLimit: Int = 0
    var historyLimit: Int {
        set {
            _historyLimit = newValue
            self.truncateItems()
        }

        get {
            return _historyLimit
        }
    }

    let disposeBag = DisposeBag()

    var defaults: UserDefaults
    var pasteboard: PasteboardWrapperType
    var pollingTimer: Timer?
    var filterText: String?

    private var _defaultSearchMode: HistorySearchMode = .fuzzyMatch

    var searchMode: HistorySearchMode {
        set {
            self.defaults.set(newValue.axID(), forKey: kSearchModeKey)
        }
        get {
            if let axID = self.defaults.string(forKey: kSearchModeKey) {
                return HistorySearchMode.searchMode(from: axID)
            }
            return _defaultSearchMode
        }
    }

    private var kSearchModeKey = "searchMode"
    private var kLegacyHistoryStoreKey = "pasteStore"
    private var kSecureHistoryStoreKey = "historyStore"

    @available(*, message: "Deprecated use historyRepo")
    private var legacyHistoryStore: [String] = []

    var historyRepo: HistoryRepo!

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
        self.pasteboard = PasteboardWrapper()
        self.historyRepo = HistoryRepo()

        if let legacyHistoryStoreDefaults = defaults.array(forKey: self.kLegacyHistoryStoreKey) {
            self.legacyHistoryStore = legacyHistoryStoreDefaults as! [String]

            self.historyRepo.loadFromDefaults()

            if self.historyRepo.items.count == 0 {
                self.historyRepo.migrate(self.legacyHistoryStore)
                self.historyRepo.saveToDefaults()
                self.historyRepo.clear()
                self.historyRepo.loadFromDefaults()
            } else {
                self.historyRepo.migrate(self.legacyHistoryStore)
            }

            defaults.removeObject(forKey: self.kLegacyHistoryStoreKey)
        } else {
            self.historyRepo.loadFromDefaults()
        }

        super.init()
    }

    private func truncateItems() {
        let limit = self.historyLimit
        if limit > 0 && historyRepo.items.count > limit {
            historyRepo.removeSubrange(limit..<historyRepo.items.count)
        }
    }

    var items: [String] {
        guard let search = self.filterText, search != ""
            else { return historyRepo.items }

        switch searchMode {
        case .fuzzyMatch:
            return historyRepo.items.fuzzySearchRankedFiltered(
                search: search,
                score: Constants.searchFuzzyMatchMinScore)
        case .regexpAnyCase:
            return historyRepo.items.regexpSearchFiltered(
                search: search,
                options: [.caseInsensitive])
        case .regexpStrictCase:
            return historyRepo.items.regexpSearchFiltered(
                search: search,
                options: [])
        }
    }

    var count: Int {
        return items.count
    }

    subscript (indexes: IndexSet) -> [String] {
        return items[indexes]
    }

    subscript (index: Int) -> String? {
        return items[safe: index]
    }

    func beginPolling() {
        guard pollingTimer == nil else { return }
        pollingTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                            target: self,
                                            selector: #selector(self.pollPasteboard),
                                            userInfo: nil,
                                            repeats: true)
    }

    func endPolling() {
        guard pollingTimer != nil else { return }
        pollingTimer?.invalidate()
        pollingTimer = nil
    }

    @discardableResult
    func toggleSearchMode() -> HistorySearchMode {
        self.searchMode = self.searchMode.next()
        return self.searchMode
    }

    func clear() {
        self.historyRepo.clearHistory()
    }

    func remove(items: IndexSet) {
        let indexes = items
            .flatMap { self.items[safe: $0] }
            .map { self.historyRepo.items.index(of: $0) }
            .flatMap { $0 }

        self.historyRepo
            .removeAtIndexes(indexes: IndexSet(indexes))
    }

    func saveToDefaults() {
        self.historyRepo.saveToDefaults()
    }

    deinit {
        self.endPolling()
    }

    @objc func pollPasteboard() {
        if let clip = self.replaceWithLatest() {
            self.historyRepo.insert(clip)
            self.truncateItems()
            self.saveToDefaults()
        }
    }

    func replaceWithLatest() -> String? {
        guard let currentClip = clipboardContent() else { return nil }

        if let indexOfClip = historyRepo.items.index(of: currentClip) {
            historyRepo.remove(at: indexOfClip)
        }

        return historyRepo.items.first == currentClip ? nil : currentClip
    }

    func clipboardContent() -> String? {
        return pasteboard.pasteboardItems?
            .first?
            .string(forType: .string)
    }
}
