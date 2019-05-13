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

    var internalHistoryLimit: Int = 0
    var historyLimit: Int {
        set {
            internalHistoryLimit = newValue
            self.truncateItems()
        }

        get {
            return internalHistoryLimit
        }
    }

    let disposeBag = DisposeBag()

    var defaults: UserDefaults
    var pasteboard: PasteboardWrapperType
    var pollingTimer: Timer?
    var filterText: String? {
        didSet {
            invalidateCaches()
        }
    }

    var removeGuard: String?

    private var internalDefaultSearchmode: HistorySearchMode = .fuzzyMatch

    var searchMode: HistorySearchMode {
        set {
            self.defaults.set(newValue.axID(), forKey: searchModeKey)
            invalidateCaches()
        }
        get {
            if let axID = self.defaults.string(forKey: searchModeKey) {
                return HistorySearchMode.searchMode(from: axID)
            }
            return internalDefaultSearchmode
        }
    }

    var internalFavoritesOnly: Bool = false
    var favoritesOnly: Bool {
        set {
            internalFavoritesOnly = newValue
            self.defaults.set(newValue, forKey: searchFavoritesOnly)
            invalidateCaches()
        }
        get {
            return internalFavoritesOnly
        }
    }

    private var searchModeKey = "searchMode"
    private var searchFavoritesOnly = "searchFavoritesOnly"
    private var legacyHistoryStoreKey = "pasteStore"

    @available(*, message: "Deprecated use historyRepo")
    private var legacyHistoryStore: [String]? = []

    var historyRepo: HistoryRepo!

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
        self.pasteboard = PasteboardWrapper()
        self.historyRepo = HistoryRepo()

        self.internalFavoritesOnly = self.defaults.bool(forKey: searchFavoritesOnly)

        if let legacyHistoryStoreDefaults = defaults.array(forKey: self.legacyHistoryStoreKey) {
            self.legacyHistoryStore = legacyHistoryStoreDefaults as? [String]

            self.historyRepo.loadFromDefaults()

            if let legacyHistoryStore = self.legacyHistoryStore {
                if self.historyRepo.items.isEmpty {
                    self.historyRepo.migrate(legacyHistoryStore)
                    self.historyRepo.saveToDefaults()
                    self.historyRepo.clear()
                    self.historyRepo.loadFromDefaults()
                } else {
                    self.historyRepo.migrate(legacyHistoryStore)
                }
            }

            defaults.removeObject(forKey: self.legacyHistoryStoreKey)
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
        invalidateCaches()
    }

    private func invalidateCaches() {
        itemsCache = nil
        dictCache = nil
    }

    var itemsCache: [String]?
    var items: [String] {
        if let cached = itemsCache {
            return cached
        }

        let historyItems: [String] =
            self.favoritesOnly ?
                historyRepo.favorites
                : historyRepo.items

        let cache: [String]
        if let search = self.filterText, search != "" {
            switch searchMode {
            case .fuzzyMatch:
                cache = historyItems.fuzzySearchRankedFiltered(
                    search: search,
                    score: Constants.searchFuzzyMatchMinScore)
            case .regexpAnyCase:
                cache = historyItems.regexpSearchFiltered(
                    search: search,
                    options: [.caseInsensitive])
            case .regexpStrictCase:
                cache = historyItems.regexpSearchFiltered(
                    search: search,
                    options: [])
            }
        } else {
            cache = historyItems
        }

        itemsCache = cache
        return cache
    }

    var dictCache: [[String: String]]?
    var dict: [[String: String]] {
        if let cached = dictCache {
            return cached
        }

        let historyItems: [[String: String]] =
            self.favoritesOnly ?
                historyRepo.favoritesDict
                : historyRepo.dict

        let cache: [[String: String]]
        if let search = self.filterText, search != "" {
            switch searchMode {
            case .fuzzyMatch:
                cache = historyItems.fuzzySearchRankedFiltered(
                    search: search,
                    score: Constants.searchFuzzyMatchMinScore)
            case .regexpAnyCase:
                cache = historyItems.regexpSearchFiltered(
                    search: search,
                    options: [.caseInsensitive])
            case .regexpStrictCase:
                cache = historyItems.regexpSearchFiltered(
                    search: search,
                    options: [])
            }
        } else {
            cache = historyItems
        }

        dictCache = cache
        return cache
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
        invalidateCaches()
        self.events.onNext(.didClearHistory)
    }

    private func itemSelectionToHistoryIndexes(items: IndexSet) -> IndexSet {
        return IndexSet(items
            .compactMap { self.items[safe: $0] }
            .map { self.historyRepo.items.index(of: $0) }
            .compactMap { $0 })
    }

    func remove(items: IndexSet) {
        let indexes = itemSelectionToHistoryIndexes(items: items)

        if indexes.contains(0) {
            self.removeGuard = self.historyRepo.items[0]
        }

        self.historyRepo
            .removeAtIndexes(indexes: indexes)
        invalidateCaches()
    }

    func toggleFavorite(items: IndexSet) {
        let indexes = itemSelectionToHistoryIndexes(items: items)
        self.historyRepo
            .toggleFavorite(indexes: indexes)
        invalidateCaches()
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
            if indexOfClip == 0 {
                return (nil, false)
            }
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
