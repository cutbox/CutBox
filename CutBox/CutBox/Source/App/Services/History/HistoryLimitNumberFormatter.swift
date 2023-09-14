//
//  HistoryLimitNumberFormatter.swift
//  CutBox
//
//  Created by Jason Milkins on 15/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Foundation

class HistoryLimitNumberFormatter: NumberFormatter {

    override var isPartialStringValidationEnabled: Bool {
        get {
            return true
        }
        // swiftlint:disable unused_setter_value
        set { fatalError("HistoryLimitNumberFormatter().isPartialStringValidationEnabled is not settable") }
        // swiftlint:enable unused_setter_value
    }

    var intOnlyRegex: NSRegularExpression? {
        do {
            return try NSRegularExpression(pattern: "^[0-9]*$",
                                           options: NSRegularExpression.Options.caseInsensitive)
        } catch { fatalError("invalid regexp in intOnlyRegex") }
    }

    override func isPartialStringValid(_ partialString: String,
                                       newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?,
                                       errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?)
        -> Bool {
            return intOnlyRegex?.matches(in: partialString,
                                         options: .anchored,
                                         range: NSRange(partialString.startIndex...,
                                                        in: partialString)).count == 1
    }
}
