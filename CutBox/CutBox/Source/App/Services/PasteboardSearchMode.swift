//
//  PasteboardSearchMode.swift
//  CutBox
//
//  Created by Jason on 8/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

enum PasteboardSearchMode {
    case fuzzyMatch, regexpAnyCase, regexpStrictCase

    func name() -> String {
        switch self{
        case .fuzzyMatch:
            return "Fuzzy matching"
        case .regexpAnyCase:
            return "RegExp (case insensitive)"
        case .regexpStrictCase:
            return "RegExp (case sensitive)"
        }
    }

    func axID() -> String {
        switch self{
        case .fuzzyMatch:
            return "fuzzyMatch"
        case .regexpAnyCase:
            return "regexpAnyCase"
        case .regexpStrictCase:
            return "regexpStrictCase"
        }
    }

    static func searchMode(from string: String) -> PasteboardSearchMode {
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

    mutating func next() -> PasteboardSearchMode {
        switch self{
        case .fuzzyMatch:
            return .regexpAnyCase
        case .regexpAnyCase:
            return .regexpStrictCase
        case .regexpStrictCase:
            return .fuzzyMatch
        }
    }
}
