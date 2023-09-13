//
//  CutBoxGetStatusItem.swift
//  CutBox
//
//  Created by jason on 11/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Cocoa

func cutBoxGetStatusItem(testing: Bool = false) -> NSStatusItem {
    guard !testing else { return NSStatusItem() }
    return NSStatusBar.system
        .statusItem(withLength: NSStatusItem.variableLength)
}
