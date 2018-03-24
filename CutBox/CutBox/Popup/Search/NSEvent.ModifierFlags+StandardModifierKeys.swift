//
//  NSEvent.ModifierFlags+StandardModifierKeys.swift
//  CutBox
//
//  Created by Jason on 23/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

enum StandardModifierKeys: Int {
    case shift
    case control
    case option
    case command
    case none
}

extension NSEvent.ModifierFlags {
    func getModifierKey() -> StandardModifierKeys? {
        let modlist:[(NSEvent.ModifierFlags, StandardModifierKeys)] =
            [(.shift,    .shift),
             (.control,  .control),
             (.option,   .option),
             (.command,  .command)]
                .flatMap { self.contains($0.0) ? $0 : nil }

        let mod = modlist.first?.1
        return mod
    }
}
