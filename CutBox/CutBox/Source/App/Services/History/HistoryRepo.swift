//
//  HistoryRepo.swift
//  CutBox
//
//  Created by Jason on 29/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

class HistoryRepo {

    private var store: [[String: String]] = []

    private var storeDefaultsKey = "historyStore"
    private var stringKey = "string"
    private var favoriteKey = "favorite"

    private var kProtectFavorites = "protectFavorites"

    var items: [String] {
       return self.store.map { $0[self.stringKey]! }
    }

    var favorites: [String] {
        return self.store
            .filter { $0[favoriteKey] == self.favoriteKey }
            .map { $0[self.stringKey]! }
    }

    var favoritesDict: [[String: String]] {
        return self.store
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
        return items.index(of: string) != nil
    }

    func index(of string: String) -> Int? {
        return items.index(of: string)
    }

    func insert(_ newElement: String, at index: Int = 0, isFavorite: Bool = false) {
        var item = [stringKey: newElement]

        if isFavorite { item[self.favoriteKey] = self.favoriteKey }

        self.store.insert(item, at: index)
    }

    func remove(at: Int) {
        self.store.remove(at: at)

        self.saveToDefaults()
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
        newElements.forEach {
            if index(of: $0) == nil  {
                self.store.append([stringKey: $0])
            }
        }
    }

    func loadFromDefaults() {
        let key = self.storeDefaultsKey

        if let historyStore = self.defaults.array(forKey: key) as? [[String:String]] {
            self.store = historyStore
        } else {
            self.store = []
        }
    }

    func saveToDefaults() {
        self.defaults.setValue(self.store, forKey: self.storeDefaultsKey)
    }

    func clearHistory() {
        self.clear()
        self.defaults.removeObject(forKey: self.storeDefaultsKey)
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
            byteFormatter.allowedUnits = [.useGB,.useMB,.useKB]
            return byteFormatter.string(fromByteCount: Int64(i))
        } catch {
            return ""
        }
    }
}
