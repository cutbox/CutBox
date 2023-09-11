//
//  HistorySearchMode.swift
//  CutBox
//
//  Created by Jason Milkins on 8/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Foundation

enum HistorySearchMode: String, CaseIterable {
    case fuzzyMatch
    case regexpAnyCase
    case regexpStrictCase
    case substringMatch

    var name: String {
        switch self {
        case .fuzzyMatch:
            return "searchmode_fuzzy".l7n
        case .regexpAnyCase:
            return "searchmode_regexp".l7n
        case .regexpStrictCase:
            return "searchmode_regexp_strict".l7n
        case .substringMatch:
            return "searchmode_substring".l7n
        }
    }

    var toolTip: String {
        self.name + "_tooltip"
    }

    static func searchMode(from string: String) -> HistorySearchMode {
        return HistorySearchMode(rawValue: string) ?? .fuzzyMatch
    }

    var next: HistorySearchMode {
        guard let currentIndex = Self.allCases.firstIndex(of: self) else {
            return .fuzzyMatch
        }
        let nextIndex = (currentIndex + 1) % Self.allCases.count
        return Self.allCases[nextIndex]
    }
}
