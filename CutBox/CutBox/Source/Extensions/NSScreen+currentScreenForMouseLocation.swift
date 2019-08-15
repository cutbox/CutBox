//
//  NSScreen+mouseCoordinates.swift
//  CutBox
//
//  Created by Jason on 3/5/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Cocoa

extension NSScreen {

    static func currentScreenForMouseLocation() -> NSScreen? {
        let mouseLocation = NSEvent.mouseLocation
        return screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) })
    }

}
