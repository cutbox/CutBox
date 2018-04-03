//
//  Array+String+SwiftyStringScore.swift
//  CutBox
//
//  Created by Jason on 3/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import SwiftyStringScore

extension Array where Element == String {
    func fuzzySearchRankedFiltered(search: String, score: Double) -> [String] {
        return self
            .map { ($0, $0.score(word: search)) }
            .filter { $0.1 > score }
            .sorted { $0.1 > $1.1 }
            .map { $0.0 }
    }
}
