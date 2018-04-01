//
//  Collection+Safe.swift
//  CutBox
//
//  Created by Jason Milkins on 25/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Element? {
        return index < self.count ? self[index] : nil
    }
}
