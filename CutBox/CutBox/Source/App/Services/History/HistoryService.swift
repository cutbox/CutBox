//
//  HistoryService.swift
//  CutBox
//
//  Created by Jason Milkins on 24/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
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

class HistoryService {

    static let shared = HistoryService()

    let events = PublishSubject<HistoryServiceEvents>()

    /// Data store wrapper
    var historyRepo: HistoryRepo!

    var internalHistoryLimit: Int = 0
    var historyLimit: Int {
        get {
            return internalHistoryLimit
        }
        set {
            internalHistoryLimit = newValue
            self.truncateItems()
        }
    }

    let disposeBag = DisposeBag()

    var defaults: UserDefaults
    var pasteboard: PasteboardWrapperType
    var pollingTimer: Timer?
    var filterText: String? {
        didSet {
            invalidateCache()
        }
    }

    var removeGuard: String?

    private var internalDefaultSearchmode: HistorySearchMode = .fuzzyMatch

    var searchMode: HistorySearchMode {
        get {
            if let rawValue = self.defaults.string(forKey: searchModeKey) {
                return HistorySearchMode.searchMode(from: rawValue)
            }
            return internalDefaultSearchmode
        }
        set {
            self.defaults.set(newValue.rawValue, forKey: searchModeKey)
            invalidateCache()
        }
    }

    var internalFavoritesOnly: Bool = false
    var favoritesOnly: Bool {
        get { internalFavoritesOnly }
        set {
            internalFavoritesOnly = newValue
            self.defaults.set(newValue, forKey: searchFavoritesOnly)
            invalidateCache()
        }
    }

    private var searchModeKey = "searchMode"
    private var searchFavoritesOnly = "searchFavoritesOnly"
    private var legacyHistoryStoreKey = "pasteStore"

    @available(*, message: "HistoryService: .legacyHistoryStore is deprecated use .historyRepo")
    private var legacyHistoryStore: [String]? = []

    init(defaults: UserDefaults = UserDefaults.standard,
         pasteboard: PasteboardWrapperType = PasteboardWrapper(),
         historyRepo: HistoryRepo = HistoryRepo(defaults: UserDefaults.standard,
                                                prefs: CutBoxPreferencesService.shared),
         prefs: CutBoxPreferencesService = CutBoxPreferencesService.shared) {

        self.defaults = defaults
        self.pasteboard = pasteboard
        self.historyRepo = historyRepo

        // swiftlint:disable identifier_name
        let migration_1_6_x = HistoryStoreMigration_1_6_x(defaults: defaults)
        if migration_1_6_x.isMigrationRequired {
            migration_1_6_x.applyTimestampsToLegacyItems()
            print("historyStore migrated to 1.6.x - timestamps added")
        }
        // swiftlint:enable identifier_name

        self.internalFavoritesOnly = self.defaults.bool(forKey: searchFavoritesOnly)

        if let legacyHistoryStoreDefaults = defaults.array(forKey: self.legacyHistoryStoreKey) {
            self.migrateLegacyHistoryStore(legacyHistoryStoreDefaults, defaults)
        } else {
            self.historyRepo.loadFromDefaults()
        }

        self.events.onNext(.didLoadDefaults) // not currently used
    }

    private func truncateItems() {
        let limit = self.historyLimit
        if limit > 0 && historyRepo.items.count > limit {
            historyRepo.removeSubrange(limit..<historyRepo.items.count)
        }
        invalidateCache()
    }

    func invalidateCache() {
        itemsCache = nil
        dictCache = nil
    }

    private var itemsCache: [String]?
    var items: [String] {
        if let cached = itemsCache {
            return cached
        }

        let historyItems: [String] =
            self.favoritesOnly ?
                historyRepo.favorites
                : historyRepo.items

        let cache: [String]
        if let search = self.filterText, !search.isEmpty {
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
            case .substringMatch:
                cache = historyItems.substringSearchFiltered(
                    search: search
                )
            }
        } else {
            cache = historyItems
        }

        itemsCache = cache
        return cache
    }

    private var dictCache: [[String: String]]?
    var dict: [[String: String]] {
        if let cached = dictCache {
            return cached
        }

        let historyItems: [[String: String]]!
        if self.favoritesOnly {
            historyItems = historyRepo.favoritesDict
        } else {
            historyItems = historyRepo.dict
        }

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
            case .substringMatch:
                cache = historyItems.substringSearchFiltered(
                    search: search
                )
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
        guard self.pollingTimer == nil else {
            return
        }

        self.pollingTimer = Timer.scheduledTimer(
            timeInterval: 0.2,
            target: self,
            selector: #selector(self.pollPasteboard),
            userInfo: nil,
            repeats: true)
    }

    func endPolling() {
        guard self.pollingTimer != nil else {
            return
        }
        self.pollingTimer?.invalidate()
        self.pollingTimer = nil
    }

    @discardableResult
    func toggleSearchMode() -> HistorySearchMode {
        self.searchMode = self.searchMode.next
        return self.searchMode
    }

    func clear() {
        self.historyRepo.clearHistory()
        self.invalidateCache()
        self.events.onNext(.didClearHistory) // not currently used
    }

    /// Clear history using timestamp predicate
    /// see historyOffsetPredicateFactory(offset: TimeInterval) -> (String) -> Bool
    func clearWithTimestampPredicate(predicate: (String) -> Bool) {
        self.historyRepo.clearHistory(timestampPredicate: predicate)
        self.invalidateCache()
    }

    private func itemSelectionToHistoryIndexes(selected: IndexSet) -> IndexSet {
        return IndexSet(selected
            .compactMap { self.items[safe: $0] }
            .map { self.historyRepo.items.firstIndex(of: $0) }
            .compactMap { $0 })
    }

    private func itemSelectionToHistoryDictIndexes(selected: IndexSet) -> IndexSet {
        let storeStrings = historyRepo.dict.map { $0["string"] }
        let dictIndexes = IndexSet(
            selected.map {
                storeStrings
                    .firstIndex(of: items[$0])!
            }
        )
        return dictIndexes
    }

    func remove(selected: IndexSet) {
        let indexes = itemSelectionToHistoryIndexes(selected: selected)

        if indexes.contains(0) {
            self.removeGuard = self.historyRepo.items[0]
        }

        self.historyRepo
            .removeAtIndexes(indexes: indexes)
        self.invalidateCache()
    }

    func toggleFavorite(items: IndexSet) {
        let indexes = itemSelectionToHistoryDictIndexes(selected: items)
        self.historyRepo
            .toggleFavorite(indexes: indexes)
        self.invalidateCache()
    }

    func saveToDefaults() {
        self.historyRepo.saveToDefaults()
        self.events.onNext(.didSaveDefaults) // not currently used
    }

    deinit {
        self.endPolling()
    }

    @objc func pollPasteboard() {
        let (clip, isFavorite) = self.replaceWithLatest()
        guard clip != nil else {
            return
        }

        if clip!.isEmpty {
            self.removeLatest()
        } else {
            self.historyRepo.insert(clip!, isFavorite: isFavorite)
            self.truncateItems()
        }
        self.saveToDefaults()
    }

    func replaceWithLatest() -> (String?, Bool) {
        guard let currentClip = clipboardContent() else {
            return (nil, false)
        }

        let isFavorite = historyRepo.favorites.contains(currentClip)

        if let removeGuard = self.removeGuard,
            currentClip == removeGuard {
            return (nil, false)
        } else {
            self.removeGuard = nil
        }

        let indexes = historyRepo.findIndexSetOf(string: currentClip)
        if let indexOfClip = indexes.first {
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

    func historyMemorySize() -> String {
        return self.historyRepo.bytesFormatted()
    }

    func removeLatest() {
        self.historyRepo.remove(at: 0)
        self.invalidateCache()
        NSPasteboard.general.clearContents()
        if let topClip = self.historyRepo.items.first {
            NSPasteboard.general.setString(topClip, forType: .string)
        }
    }

    func setTimeFilter(seconds: Double?) {
        self.historyRepo.timeFilter = seconds
        self.invalidateCache()
        self.events.onNext(.didLoadDefaults) // not currently used
    }

    func migrateLegacyHistoryStore(_ legacyHistoryStoreDefaults: [Any], _ defaults: UserDefaults) {
        self.legacyHistoryStore = legacyHistoryStoreDefaults as? [String]
        self.historyRepo.loadFromDefaults()

        if let legacyHistoryStore = self.legacyHistoryStore {
            self.historyRepo.migrateLegacyPasteStore(legacyHistoryStore)
            self.historyRepo.saveToDefaults()
        }

        defaults.removeObject(forKey: self.legacyHistoryStoreKey)
    }
}
