//
//  FakeKeyEvents.swift
//  CutBox
//
//  Created by Jason on 26/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation
import Magnet

func send(fakeKey key: String, useCommandFlag: Bool) {
    let sourceRef = CGEventSource(stateID: .combinedSessionState)

    let asciiRange: [UInt16] = (0...255).map { UInt16($0) }
    let asciiMap: [UniChar] = asciiRange.map {

        guard let event: CGEvent = CGEvent(
            keyboardEventSource: sourceRef, virtualKey: $0, keyDown: true
            ) else { fatalError("Cannot generate CGEvent for :\($0)") }

        var (char, len) = (UniChar(), 0)

        event.keyboardGetUnicodeString(maxStringLength: 1,
                                       actualStringLength: &len,
                                       unicodeString: &char)
        return char
    }

    if let longInt = key[key.startIndex].ascii {
        let keyUniChar: UniChar = numericCast(longInt)
        let index = asciiMap.index(of: keyUniChar)
        let keyCode = asciiRange[index!]
        send(fakeKey: keyCode, useCommandFlag: useCommandFlag)
    }
}

extension Character {
    var ascii: UInt32? {
        let asciiCode: UInt32? = String(self).unicodeScalars.filter{$0.isASCII}.first?.value
        return asciiCode
    }
}

func send(fakeKey keyCode: CGKeyCode, useCommandFlag: Bool) {
    let sourceRef = CGEventSource(stateID: .combinedSessionState)

    if sourceRef == nil {
        NSLog("No event source")
        return
    }

    let keyDownEvent = CGEvent(
        keyboardEventSource: sourceRef,
        virtualKey: keyCode,
        keyDown: true
    )

    if useCommandFlag {
        keyDownEvent?.flags = .maskCommand
    }

    let keyUpEvent = CGEvent(
        keyboardEventSource: sourceRef,
        virtualKey: keyCode,
        keyDown: false
    )

    keyDownEvent?.post(tap: .cghidEventTap)
    keyUpEvent?.post(tap: .cghidEventTap)
}

