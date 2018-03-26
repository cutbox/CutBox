//
//  FakeKey.swift
//  CutBox
//
//  Created by Jason on 26/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

class FakeKey {
    static func send(_ keyCode: CGKeyCode, withCommandFlag setFlag: Bool) {
        let sourceRef = CGEventSource(stateID: .combinedSessionState)

        if sourceRef == nil {
            NSLog("No event source")
            return
        }

        let eventDown = CGEvent(keyboardEventSource: sourceRef,
                                virtualKey: keyCode,
                                keyDown: true)
        if setFlag {
            eventDown?.flags = .maskCommand
        }

        let eventUp = CGEvent(keyboardEventSource: sourceRef,
                              virtualKey: keyCode,
                              keyDown: false)

        eventDown?.post(tap: .cghidEventTap)
        eventUp?.post(tap: .cghidEventTap)
    }
}
