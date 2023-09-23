//
//  NSScreen+mouseCoordinates.swift
//  CutBox
//
//  Created by Jason Milkins on 3/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

var NSScreenTesting = false
var NSScreenMockScreen: NSScreen?
extension NSScreen {
    static func currentScreenForMouseLocation() -> NSScreen? {
        if NSScreenTesting {
            return NSScreenMockScreen
        }
        let mouseLocation = NSEvent.mouseLocation
        return screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) })
    }
}
