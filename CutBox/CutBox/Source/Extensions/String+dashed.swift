//
//  String+dashed.swift
//  CutBox
//
//  Created by jason on 13/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

extension String {
    var dashed: String {
        var copy = self
        var result = ""

        if self.contains(where: { $0.isWhitespace }) {
            copy = self.lowercased()
        }

        for (index, character) in copy.enumerated() {
            if character.isWhitespace {
                if index > 0 {
                    result += "-"
                }
            } else if character.isUppercase {
                if index > 0 {
                    result += "-"
                }
                result += String(character).lowercased()
            } else {
                result += String(character)
            }
        }
        return result
    }
}
