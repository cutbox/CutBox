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

enum HistoryServiceEvents {
    case didSaveDefaults
    case didLoadDefaults
    case didClearHistory
}

class HistoryService: NSObject {

    static let shared = HistoryService()

    let events = PublishSubject<HistoryServiceEvents>()

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

    var removeGuard: String?

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

    var _favoritesOnly: Bool = false
    var favoritesOnly: Bool {
        set {
            _favoritesOnly = newValue
            self.defaults.set(newValue, forKey: kSearchFavoritesOnly)
        }
        get {
            return _favoritesOnly
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

        self._favoritesOnly = self.defaults.bool(forKey: kSearchFavoritesOnly)

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

        self.events.onNext(.didLoadDefaults)

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
        self.events.onNext(.didClearHistory)
    }

    private func itemSelectionToHistoryIndexes(items: IndexSet) -> IndexSet {
        return IndexSet(items
            .flatMap { self.items[safe: $0] }
            .map { self.historyRepo.items.index(of: $0) }
            .flatMap { $0 })
    }

    func remove(items: IndexSet) {
        let indexes = itemSelectionToHistoryIndexes(items: items)

        if indexes.contains(0) {
            self.removeGuard = self.historyRepo.items[0]
        }

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
        self.events.onNext(.didSaveDefaults)
    }

    deinit {
        self.endPolling()
    }

    @objc func pollPasteboard() {
        let (clip, isFavorite) = self.replaceWithLatest()

        guard clip != nil else { return }

        self.historyRepo.insert(clip!, isFavorite: isFavorite)
        self.truncateItems()
        self.saveToDefaults()
    }

    func replaceWithLatest() -> (String?, Bool) {
        guard let currentClip = clipboardContent() else { return (nil, false) }

        let isFavorite = historyRepo.favorites.contains(currentClip)

        if let removeGuard = self.removeGuard,
            currentClip == removeGuard {
            return (nil, false)
        } else {
            self.removeGuard = nil
        }

        if let indexOfClip = historyRepo.items.index(of: currentClip) {
            if indexOfClip == 0 { return (nil, false) }
            historyRepo.remove(at: indexOfClip)
        }

        return (
            historyRepo.items.first == currentClip
            ? nil
            : currentClip,
            isFavorite
        )
    }

    func clipboardContent() -> String? {
        return pasteboard.pasteboardItems?
            .first?
            .string(forType: .string)
    }

    func bytesFormatted() -> String {
        return self.historyRepo.bytesFormatted()
    }
}
