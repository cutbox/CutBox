//
//  Collection+Safe.swift
//  CutBox
//
//  Created by Jason Milkins on 25/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Foundation

extension Array {
    subscript(safe index: Int) -> Element? {
        let inRange = index < self.count && index > -1
        return inRange ? self[index] : nil
    }
}
