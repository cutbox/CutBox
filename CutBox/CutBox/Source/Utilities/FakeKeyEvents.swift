//
//  FakeKeyEvents.swift
//  CutBox
//
//  Created by Jason on 26/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation
import Magnet

fileprivate extension Character {
    var ascii: UInt32? {
        let asciiCode: UInt32? = String(self).unicodeScalars.filter{$0.isASCII}.first?.value
        return asciiCode
    }
}

func send(fakeKey key: String, useCommandFlag: Bool) {
    let sourceRef = CGEventSource(stateID: .combinedSessionState)

    if sourceRef == nil {
        NSLog("No event source")
        return
    }

    let asciiRange: [UInt16] = (0...255).map { UInt16($0) }
    var asciiMap: [UniChar:UInt16] = [:]

    asciiRange.forEach {
        guard let event: CGEvent = CGEvent(
            keyboardEventSource: sourceRef,
            virtualKey: $0,
            keyDown: true
            )

            else { fatalError("Cannot generate CGEvent for :\($0)") }

        var (char, len) = (UniChar(), 0)
        event.keyboardGetUnicodeString(
            maxStringLength: 1,
            actualStringLength: &len,
            unicodeString: &char
        )

        asciiMap[char] = $0
    }

    if let asciiCode = key[key.startIndex].ascii {
        let keyUniChar: UniChar = numericCast(asciiCode)
        guard let keyCode = asciiMap[keyUniChar]
            else { fatalError("Cannot get ASCII value for key: \(key)") }

        send(fakeKey: keyCode, useCommandFlag: useCommandFlag)
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

