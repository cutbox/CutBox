//
//  Array+removeAtIndexes.swift
//  CutBox
//
//  Created by Jason Milkins on 29/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeAtIndexes(indexes: IndexSet) {
        var idx: Index? = indexes.last
        while idx != nil {
            // implicit guard so we can safely force unwrap
            self.remove(at: idx!)
            idx = indexes.integerLessThan(idx!)
        }
    }
}

extension Array where Element == [String: String] {
    mutating func removeAll(protectFavorites: Bool) {
        if protectFavorites {
            let favorites: [[String: String]] = self.filter { $0["favorite"] == "favorite" }
            self.removeAll()
            self.append(contentsOf: favorites)
        } else {
            self.removeAll()
        }
    }
}
