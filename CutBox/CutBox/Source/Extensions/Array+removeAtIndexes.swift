//
//  Array+removeAtIndexes.swift
//  CutBox
//
//  Created by Jason on 29/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

extension Array {
    mutating func removeAtIndexes(indexes: IndexSet) {
        var i:Index? = indexes.last
        while i != nil {
            self.remove(at: i!)
            i = indexes.integerLessThan(i!)
        }
    }
}
