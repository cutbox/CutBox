//
//  PasteboardService.swift
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

class PasteboardService: NSObject {

    static let shared = PasteboardService()

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

    private var _defaultSearchMode: PasteboardSearchMode = .fuzzyMatch

    var searchMode: PasteboardSearchMode {
        set {
            self.defaults.set(newValue.axID(), forKey: kSearchModeKey)
        }
        get {
            if let axID = self.defaults.string(forKey: kSearchModeKey) {
                return PasteboardSearchMode.searchMode(from: axID)
            }
            return _defaultSearchMode
        }
    }

    private var kSearchModeKey = "searchMode"
    private var kPasteStoreKey = "pasteStore"
    private var pasteStore: [String] = []

    override init() {
        self.defaults = NSUserDefaultsController.shared.defaults
        self.pasteboard = PasteboardWrapper()

        if let pasteStoreDefaults = defaults.array(forKey: kPasteStoreKey) {
            self.pasteStore = pasteStoreDefaults as! [String]
        } else {
            self.pasteStore = []
        }

        super.init()
    }

    private func truncateItems() {
        let limit = self.historyLimit
        if limit > 0 && pasteStore.count > limit {
            pasteStore.removeSubrange(limit..<pasteStore.count)
        }
    }

    var items: [String] {
        guard let search = self.filterText, search != ""
            else { return pasteStore }

        switch searchMode {
        case .fuzzyMatch:
            return pasteStore.fuzzySearchRankedFiltered(
                search: search,
                score: Constants.searchFuzzyMatchMinScore)
        case .regexpAnyCase:
            return pasteStore.regexpSearchFiltered(
                search: search,
                options: [.caseInsensitive])
        case .regexpStrictCase:
            return pasteStore.regexpSearchFiltered(
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
    func toggleSearchMode() -> PasteboardSearchMode {
        self.searchMode = self.searchMode.next()
        return self.searchMode
    }

    func clear() {
        clearDefaults()
        pasteStore = []
    }

    func remove(items: IndexSet) {
        let indexes = items
            .flatMap { self.items[safe: $0] }
            .map { self.pasteStore.index(of: $0) }
            .flatMap { $0 }

        self.pasteStore
            .removeAtIndexes(indexes: IndexSet(indexes))
    }

    func clearDefaults() {
        defaults.removeObject(forKey: kPasteStoreKey)
    }

    func saveToDefaults() {
        defaults.set(self.pasteStore, forKey: kPasteStoreKey)
    }

    deinit {
        self.stopTimer()
    }

    @objc func pollPasteboard() {
        if let clip = self.replaceWithLatest() {
            self.pasteStore.insert(clip, at: 0)
            self.truncateItems()
            self.saveToDefaults()
        }
    }

    func replaceWithLatest() -> String? {
        guard let currentClip = clipboardContent() else { return nil }

        if let indexOfClip = pasteStore.index(of: currentClip) {
            pasteStore.remove(at: indexOfClip)
        }

        return pasteStore.first == currentClip ? nil : currentClip
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
