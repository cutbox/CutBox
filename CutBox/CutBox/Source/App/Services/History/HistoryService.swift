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

    var favoritesOnly: Bool {
        set {
            self.defaults.set(newValue, forKey: kSearchFavoritesOnly)
        }
        get {
            return self.defaults.bool(forKey: kSearchFavoritesOnly)
        }
    }

    private var kSearchModeKey = "searchMode"
    private var kSearchFavoritesOnly = "searchFavoritesOnly"
    private var kLegacyHistoryStoreKey = "pasteStore"

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
        let historyItems: [String] =
            self.favoritesOnly ?
                historyRepo.favorites
                : historyRepo.items

        guard let search = self.filterText, search != ""
            else { return historyItems }

        switch searchMode {
        case .fuzzyMatch:
            return historyItems.fuzzySearchRankedFiltered(
                search: search,
                score: Constants.searchFuzzyMatchMinScore)
        case .regexpAnyCase:
            return historyItems.regexpSearchFiltered(
                search: search,
                options: [.caseInsensitive])
        case .regexpStrictCase:
            return historyItems.regexpSearchFiltered(
                search: search,
                options: [])
        }
    }


    var dict: [[String: String]] {
        let historyItems: [[String: String]] =
            self.favoritesOnly ?
                historyRepo.favoritesDict
                : historyRepo.dict

        guard let search = self.filterText, search != ""
            else { return historyItems }

        switch searchMode {
        case .fuzzyMatch:
            return historyItems.fuzzySearchRankedFiltered(
                search: search,
                score: Constants.searchFuzzyMatchMinScore)
        case .regexpAnyCase:
            return historyItems.regexpSearchFiltered(
                search: search,
                options: [.caseInsensitive])
        case .regexpStrictCase:
            return historyItems.regexpSearchFiltered(
                search: search,
                options: [])
        }
    }


    var count: Int {
        return items.count
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

    private func itemSelectionToHistoryIndexes(items: IndexSet) -> IndexSet {
        return IndexSet(items
            .flatMap { self.items[safe: $0] }
            .map { self.historyRepo.items.index(of: $0) }
            .flatMap { $0 })
    }

    func remove(items: IndexSet) {
        let indexes = itemSelectionToHistoryIndexes(items: items)
        self.historyRepo
            .removeAtIndexes(indexes: indexes)
    }

    func toggleFavorite(items: IndexSet) {
        let indexes = itemSelectionToHistoryIndexes(items: items)
        self.historyRepo
            .toggleFavorite(indexes: indexes)        
    }

    func saveToDefaults() {
        self.historyRepo.saveToDefaults()
    }

    deinit {
        self.endPolling()
    }

    @objc func pollPasteboard() {
        if let clip = self.replaceWithLatest() {
            let isFavorite = historyRepo.favorites.contains(clip)
            self.historyRepo.insert(clip, isFavorite: isFavorite)
            self.truncateItems()
            self.saveToDefaults()
        }
    }

    func replaceWithLatest() -> String? {
        guard let currentClip = clipboardContent() else { return nil }

        if let indexOfClip = historyRepo.items.index(of: currentClip) {
            if indexOfClip == 0 { return nil }
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
