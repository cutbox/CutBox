//
//  NSEvent+CarbonConvenience.swift
//  CutBox
//
//  Created by Jason Milkins on 19/4/18.
//  Copyright © 2018-2022 ocodo. All rights reserved.
//

import Cocoa

extension NSEvent {
    var modifiers: NSEvent.ModifierFlags {
        return self.modifierFlags.intersection(.deviceIndependentFlagsMask)
    }

    // For simple use with Carbon.HIToolbox
    var key: Int {
        return Int(self.keyCode)
    }
}
