//
//  HistoryRepo.swift
//  CutBox
//
//  Created by Jason on 29/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

class HistoryRepo {

    private var store: [[String:String]] = []

    private var storeDefaultsKey = "historyStore"
    private var stringKey = "string"
    private var favoriteKey = "favorite"
    private var favoriteString = "★"

    var items: [String] {
       return self.store.map { $0[self.stringKey]! }
    }

    var favorites: [String] {
        return self.store
            .filter { $0[favoriteKey] != "" }
            .map { $0[self.stringKey]! }
    }

    var dict: [[String:String]] {
        return self.store
    }

    private var defaults: UserDefaults

    init(defaults: UserDefaults = UserDefaults.standard) {
        self.defaults = defaults
    }

    func clear() {
        self.store = []
    }

    func hasString(_ string: String) -> Bool {
        return items.index(of: string) != nil
    }

    func index(of string: String) -> Int? {
        return items.index(of: string)
    }

    func insert(_ newElement: String, at: Int = 0) {
        self.store.insert([stringKey: newElement], at: at)
    }

    func remove(at: Int) {
        self.store.remove(at: at)
    }

    func removeAtIndexes(indexes: IndexSet) {
        self.store.removeAtIndexes(indexes: indexes)
    }

    func toggleFavorite(indexes: IndexSet) {
        for i in indexes {
            let item = self.store[i]

            let isFavorite = item[self.favoriteKey] != self.favoriteString
                ? self.favoriteString
                : ""

            self.store[i][favoriteKey] = isFavorite
        }

        self.saveToDefaults()
    }

    func removeSubrange(_ bounds: Range<Int>) {
        self.store.removeSubrange(bounds)
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
}
