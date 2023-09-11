//
//  Array+MenuItems.swift
//  CutBox
//
//  Created by jason on 11/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Cocoa

extension Array where Element == NSMenuItem {
    func find(axID: String) -> CutBoxBaseMenuItem {
        guard let found = self.first(where: { $0.accessibilityIdentifier() == axID }),
              let cutboxMenuItem = found as? CutBoxBaseMenuItem
        else { fatalError("Could not located menu item: \(axID)") }

        return cutboxMenuItem
    }
}
