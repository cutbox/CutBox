//
//  String+Utils.swift
//  CutBox
//
//  Created by denis.st on 29/4/19.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Foundation

extension String {
    func truncate(limit: Int, trailing: String = "…") -> String {
        guard limit > 0 else {
            return ""
        }
        if self.count > limit {
            return String(self.prefix(limit - 1)) + trailing
        } else {
            return self
        }
    }
}
