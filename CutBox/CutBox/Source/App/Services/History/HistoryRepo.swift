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

    private var store: [[String: String]] = []

    private var historyStoreKey = "historyStore"
    private var stringKey = "string"
    private var favoriteKey = "favorite"
    private var timestampKey = "timestamp"

    public var timeFilter: Double?

    private var kProtectFavorites = "protectFavorites"

    var items: [String] {
        if let seconds = self.timeFilter {
            let latest = secondsBeforeTimeNowISO8601(seconds: seconds)
            return self.dict
                .filter {
                    if let timestamp = $0[self.timestampKey] {
                        return timestamp > latest
                    } else {
                        return false
                    }
                }
                .map { $0[self.stringKey]! }
        } else {
            return self.dict
                .map { $0[self.stringKey]! }
        }
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

    func hasString(_ string: String) -> Bool {
        return items.firstIndex(of: string) != nil
    }

    func index(of string: String) -> Int? {
        return items.firstIndex(of: string)
    }

    func insert(_ newElement: String, at index: Int = 0, isFavorite: Bool = false, date: Date = Date()) {
        var item = [stringKey: newElement]
        item[self.timestampKey] = iso8601(date: date)

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

    func migrate(_ newElements: [String], at: Int = 0) {
        newElements.reversed().forEach {
            if index(of: $0) == nil {
                self.insert($0)
            }
        }
    }

    func loadFromDefaults() {
        let key = self.historyStoreKey
        if let historyStore = self.defaults.array(forKey: key) as? [[String: String]] {
            self.store = historyStore
        } else {
            self.store = []
        }
    }

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

    func bytes() throws -> Int {
        let data = try PropertyListSerialization.data(
            fromPropertyList: store,
            format: .binary,
            options: .bitWidth)

        return data.count
    }

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

    func iso8601(date: Date) -> String {
        return ISO8601DateFormatter().string(from: date)
    }

    func secondsBeforeTimeNowISO8601(seconds: Double) -> String {
        let date = Date(timeIntervalSinceNow: -seconds)
        return iso8601(date: date)
    }
}
