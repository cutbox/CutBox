//
//  Array+String+SwiftyStringScore.swift
//  CutBox
//
//  Created by Jason Milkins on 3/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import SwiftyStringScore

extension Array where Element == [String: String] {

    func fuzzySearchRankedFiltered(search: String, score: Double) -> [[String: String]] {
        return self
            .map { ($0, $0["string"]!.score(word: search)) }
            .filter { $0.1 > score }
            .sorted { $0.1 > $1.1 }
            .map { $0.0 }
    }

    func regexpSearchFiltered(search: String, options: NSRegularExpression.Options) -> [[String: String]] {
        // We need a *do* block because the incoming
        // search string might be an invalid regexp.
        // Return an empty array in that case.
        do {
            let regexp: NSRegularExpression =
                try NSRegularExpression(pattern: search,
                                        options: options)
            return self
                .filter {
                    let range = NSRange($0["string"]!.startIndex..., in: $0["string"]!)
                    return regexp.numberOfMatches(in: $0["string"]!, range: range) > 0
            }
        } catch {
            return []
        }
    }
}

extension Array where Element == String {

    func fuzzySearchRankedFiltered(search: String, score: Double) -> [String] {
        return self
            .map { ($0, $0.score(word: search)) }
            .filter { $0.1 > score }
            .sorted { $0.1 > $1.1 }
            .map { $0.0 }
    }

    func regexpSearchFiltered(search: String, options: NSRegularExpression.Options) -> [String] {
        // We need a *do* block because the incoming
        // search string might be an invalid regexp.
        // Return an empty array in that case.
        do {
            let regexp: NSRegularExpression =
                try NSRegularExpression(pattern: search,
                                         options: options)
            return self
                .filter {
                    let range = NSRange($0.startIndex..., in: $0)
                    return regexp.numberOfMatches(in: $0, range: range) > 0
            }
        } catch {
            return []
        }
    }
}
