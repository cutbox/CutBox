//
//  HistoryRepo.swift
//  CutBox
//
//  Created by Jason Milkins on 29/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

// swiftlint:disable identifier_name

import Foundation

class HistoryRepo {

    /// Clip items store (cached from/to defaults by history service)
    private var store: [[String: String]] = []

    /// dict keys of clip items
    private var historyStoreKey = "historyStore"
    private var stringKey = "string"
    private var favoriteKey = "favorite"
    private var timestampKey = "timestamp"

    /// Optional time filter
    public var timeFilter: Double?

    /// preferences defaults key for protect favorites flag
    private var kProtectFavorites = "protectFavorites"

    func timeFilterPredicate(item: [String: String], earliest: String) -> Bool {
        if let timestamp = item[self.timestampKey] {
            return earliest < timestamp
        } else {
            return false
        }
    }

    var items: [String] {
        if let seconds = self.timeFilter {
            let latest = secondsBeforeTimeNowAsISO8601(seconds: seconds)
            return self.dict
                .filter { timeFilterPredicate(item: $0, earliest: latest) }
                .map { $0[self.stringKey]! }
        }

        return self.dict
          .map { $0[self.stringKey]! }
    }

    var favorites: [String] {
        return self.dict
            .filter { $0[favoriteKey] == self.favoriteKey }
            .map { $0[self.stringKey]! }
    }

    var favoritesDict: [[String: String]] {
        return self.dict
            .filter { $0[favoriteKey] == self.favoriteKey }
    }

    var dict: [[String: String]] {
        return self.store
    }

    private var defaults: UserDefaults
    private var prefs: CutBoxPreferencesService

    init(defaults: UserDefaults = UserDefaults.standard,
         prefs: CutBoxPreferencesService = CutBoxPreferencesService.shared) {
        self.defaults = defaults
        self.prefs = prefs
    }

    func clear() {
        self.store.removeAll(protectFavorites: prefs.protectFavorites)
        self.saveToDefaults()
    }

    func index(of string: String) -> Int? {
        return items.firstIndex(of: string)
    }

    func insert(_ newElement: String, at index: Int = 0, isFavorite: Bool = false, date: Date? = Date()) {
        var item = [stringKey: newElement]

        if let unwrappedDate = date {
            let timestamp = ISO8601DateFormatter().string(from: unwrappedDate)
            item[self.timestampKey] = timestamp
        }

        if isFavorite {
            item[self.favoriteKey] = self.favoriteKey
        }

        self.store.insert(item, at: index)
    }

    func remove(at: Int) {
        if at >= 0 && self.store.count > at {
            self.store.remove(at: at)
            self.saveToDefaults()
        }
    }

    func removeAtIndexes(indexes: IndexSet) {
        self.store.removeAtIndexes(indexes: indexes)
        self.saveToDefaults()
    }

    func findIndexSetOf(string: String) -> IndexSet {
        var indexes = IndexSet()
        for item in dict where item[stringKey] == string {
            if let index = dict.firstIndex(of: item) {
                indexes.insert(index)
            }
        }
        return indexes
    }

    func toggleFavorite(indexes: IndexSet) {
        for i in indexes {
            toggleFavorite(at: i)
        }
        self.saveToDefaults()
    }

    func toggleFavorite(at i: Int) {
        let item = self.store[i]
        let isFavorite = item[self.favoriteKey] == self.favoriteKey
            ? ""
            : self.favoriteKey
        self.store[i][favoriteKey] = isFavorite
    }

    func removeSubrange(_ bounds: Range<Int>) {
        self.store.removeSubrange(bounds)
        self.saveToDefaults()
    }

    func migrateLegacyPasteStore(_ newElements: [String], at: Int = 0) {
        newElements.reversed().forEach {
            if index(of: $0) == nil {
                self.insert($0)
            }
        }
    }

    /// Used to read user defaults to in memory history store
    func loadFromDefaults() {
        let key = self.historyStoreKey
        if let historyStore = self.defaults.array(forKey: key) as? [[String: String]] {
            self.store = historyStore
        } else {
            self.store = []
        }
    }

    /// Used to persist in memory history store to user defaults
    func saveToDefaults() {
        self.defaults.setValue(self.store, forKey: self.historyStoreKey)
    }

    func clearHistory() {
        self.clear()
        self.defaults.removeObject(forKey: self.historyStoreKey)
    }

    /// Clear the history using a timestampPredicate
    ///
    /// Favorites are protected when `prefs.protectFavorites` is enabled
    ///
    /// Items without a timestamp will be ignored.
    ///
    /// see also: `historyOffsetPredicateFactory(offset: TimeInterval?)`
    func clearHistory(timestampPredicate: (String) -> Bool) {
        let keep = self.store.filter {
            if $0[favoriteKey] != nil {
                if prefs.protectFavorites {
                    return true
                }
            }

            if let timestamp: String = $0[timestampKey] {
                return !timestampPredicate(timestamp)
            }

            return true
        }

        self.store = keep
        saveToDefaults()
    }

    /// Size of history repo in bytes
    func bytes() throws -> Int {
        let data = try PropertyListSerialization.data(
            fromPropertyList: store,
            format: .binary,
            options: .bitWidth)

        return data.count
    }

    /// Bytes formatter
    func bytesFormatted() -> String {
        do {
            let i: Int = try bytes()
            let byteFormatter = ByteCountFormatter()
            byteFormatter.allowedUnits = [.useGB, .useMB, .useKB]
            return byteFormatter.string(fromByteCount: Int64(i))
        } catch {
            return ""
        }
    }
}
