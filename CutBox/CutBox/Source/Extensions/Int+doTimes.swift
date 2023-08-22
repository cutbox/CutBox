//
//  Int+doTimes.swift
//  CutBox
//
//  Created by jason on 22/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

extension Int {
    /// Loop equivalent to Ruby's `int.times {|i| code }`
    /// Usage: `doTimes { code with $0 }`
    func doTimes(_ code: (Int) -> Void) {
        guard self > 0 else { return }
        for i in 0..<self {
            code(i)
        }
    }

    /// Loop equivalent to Ruby's `int.times { code }`
    /// Usage: `doTimes { code }`
    func doTimes(_ code: () -> Void) {
        guard self > 0 else { return }
        for _ in 0..<self {
            code()
        }
    }
}
