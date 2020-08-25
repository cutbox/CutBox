//
//  HistorySearchMode.swift
//  CutBox
//
//  Created by Jason Milkins on 8/4/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Foundation

enum HistorySearchMode {
    case fuzzyMatch, regexpAnyCase, regexpStrictCase

    func name() -> String {
        switch self {
        case .fuzzyMatch:
            return "searchmode_fuzzy".l7n
        case .regexpAnyCase:
            return "searchmode_regexp".l7n
        case .regexpStrictCase:
            return "searchmode_regexp_strict".l7n
        }
    }

    func toolTip() -> String {
        switch self {
        case .fuzzyMatch:
            return "searchmode_fuzzy_tooltip".l7n
        case .regexpAnyCase:
            return "searchmode_regexp_tooltip".l7n
        case .regexpStrictCase:
            return "searchmode_regexp_strict_tooltip".l7n
        }
    }

    func axID() -> String {
        switch self {
        case .fuzzyMatch:
            return "fuzzyMatch"
        case .regexpAnyCase:
            return "regexpAnyCase"
        case .regexpStrictCase:
            return "regexpStrictCase"
        }
    }

    static func searchMode(from string: String) -> HistorySearchMode {
        switch string {
        case "fuzzyMatch":
            return .fuzzyMatch
        case "regexpAnyCase":
            return .regexpAnyCase
        case "regexpStrictCase":
            return .regexpStrictCase
        default:
            return .fuzzyMatch
        }
    }

    mutating func next() -> HistorySearchMode {
        switch self {
        case .fuzzyMatch:
            return .regexpAnyCase
        case .regexpAnyCase:
            return .regexpStrictCase
        case .regexpStrictCase:
            return .fuzzyMatch
        }
    }

}
