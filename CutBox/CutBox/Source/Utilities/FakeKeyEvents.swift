//
//  FakeKeyEvents.localized().swift
//  CutBox
//
//  Created by Jason on 26/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

func send(fakeKey keyCode: CGKeyCode, useCommandFlag: Bool) {
    let sourceRef = CGEventSource(stateID: .combinedSessionState)

    if sourceRef == nil {
        NSLog("No event source")
        return
    }

    let keyDownEvent = CGEvent(keyboardEventSource: sourceRef,
                               virtualKey: keyCode,
                               keyDown: true)
    if useCommandFlag {
        keyDownEvent?.flags = .maskCommand
    }

    let keyUpEvent = CGEvent(keyboardEventSource: sourceRef,
                             virtualKey: keyCode,
                             keyDown: false)

    keyDownEvent?.post(tap: .cghidEventTap)
    keyUpEvent?.post(tap: .cghidEventTap)
}

