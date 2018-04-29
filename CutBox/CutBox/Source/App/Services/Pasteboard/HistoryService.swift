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

    private var legacyHistoryStore: [String] = []

    override init() {
        self.defaults = NSUserDefaultsController.shared.defaults
        self.pasteboard = PasteboardWrapper()

        if let pasteStoreDefaults = defaults.array(forKey: kLegacyHistoryStoreKey) {
            self.legacyHistoryStore = pasteStoreDefaults as! [String]
        } else {
            self.legacyHistoryStore = []
        }

        super.init()
    }

    private func truncateItems() {
        let limit = self.historyLimit
        if limit > 0 && legacyHistoryStore.count > limit {
            legacyHistoryStore.removeSubrange(limit..<legacyHistoryStore.count)
        }
    }

    var items: [String] {
        guard let search = self.filterText, search != ""
            else { return legacyHistoryStore }

        switch searchMode {
        case .fuzzyMatch:
            return legacyHistoryStore.fuzzySearchRankedFiltered(
                search: search,
                score: Constants.searchFuzzyMatchMinScore)
        case .regexpAnyCase:
            return legacyHistoryStore.regexpSearchFiltered(
                search: search,
                options: [.caseInsensitive])
        case .regexpStrictCase:
            return legacyHistoryStore.regexpSearchFiltered(
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

    func startTimer() {
        guard pollingTimer == nil else { return }
        pollingTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                            target: self,
                                            selector: #selector(self.pollPasteboard),
                                            userInfo: nil,
                                            repeats: true)
    }

    func stopTimer() {
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
        clearDefaults()
        legacyHistoryStore = []
    }

    func remove(items: IndexSet) {
        let indexes = items
            .flatMap { self.items[safe: $0] }
            .map { self.legacyHistoryStore.index(of: $0) }
            .flatMap { $0 }

        self.legacyHistoryStore
            .removeAtIndexes(indexes: IndexSet(indexes))
    }

    func clearDefaults() {
        defaults.removeObject(forKey: kLegacyHistoryStoreKey)
    }

    func saveToDefaults() {
        defaults.set(self.legacyHistoryStore, forKey: kLegacyHistoryStoreKey)
    }

    deinit {
        self.stopTimer()
    }

    @objc func pollPasteboard() {
        if let clip = self.replaceWithLatest() {
            self.legacyHistoryStore.insert(clip, at: 0)
            self.truncateItems()
            self.saveToDefaults()
        }
    }

    func replaceWithLatest() -> String? {
        guard let currentClip = clipboardContent() else { return nil }

        if let indexOfClip = legacyHistoryStore.index(of: currentClip) {
            legacyHistoryStore.remove(at: indexOfClip)
        }

        return legacyHistoryStore.first == currentClip ? nil : currentClip
    }

    func clipboardContent() -> String? {
        return pasteboard.pasteboardItems?
            .first?
            .string(forType: .string)
    }
}

extension Array {
    mutating func removeAtIndexes(indexes: IndexSet) {
        var i:Index? = indexes.last
        while i != nil {
            self.remove(at: i!)
            i = indexes.integerLessThan(i!)
        }
    }
}
