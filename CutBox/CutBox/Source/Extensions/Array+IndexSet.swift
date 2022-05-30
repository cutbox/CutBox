//
//  Array+IndexSet.swift
//  CutBox
//
//  Created by Jason Milkins on 7/4/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Foundation

extension Array {

    subscript(_ indexSet: IndexSet) -> [Element] {
        var result: [Element] = []
        indexSet.forEach {
            if $0 < self.count && $0 > -1 {
                result.append(self[$0])
            }
        }
        return result
    }
}
