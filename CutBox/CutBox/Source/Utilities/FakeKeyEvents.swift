//
//  FakeKeyEvents.swift
//  CutBox
//
//  Created by Jason on 26/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

import Magnet
import Carbon

func transformKeyCode(_ keyCode: Int) -> String {
    let inputSource = unsafeBitCast(
        TISGetInputSourceProperty(
            TISCopyCurrentASCIICapableKeyboardLayoutInputSource().takeUnretainedValue(),
            kTISPropertyUnicodeKeyLayoutData
    ), to: CFData.self)

    var deadKeyState: UInt32 = 0
    var char = UniChar()
    var length = 0

    CoreServices.UCKeyTranslate(unsafeBitCast(CFDataGetBytePtr(inputSource),
                                              to: UnsafePointer<CoreServices.UCKeyboardLayout>.self),
                                UInt16(keyCode),
                                UInt16(CoreServices.kUCKeyActionDisplay),
                                UInt32(0),
                                UInt32(LMGetKbdType()),
                                OptionBits(CoreServices.kUCKeyTranslateNoDeadKeysBit),

                                &deadKeyState,
                                1,
                                &length,
                                &char)

    return NSString(characters: &char, length: length).uppercased
}

func keyCodeTranslationTable() -> [String:Int] {
    return (0x00...0x7E).reduce([String:Int]()) { (result, code) -> [String:Int] in
        var r = result
        r[transformKeyCode(code)] = code
        return r
    }
}

func stringToKeyCode(_ key: String) -> Int {
    guard key.count == 1 else { fatalError("Only single char strings can be used") }

    let translationTable = keyCodeTranslationTable()

    guard let keyCode = translationTable[key]
        else { fatalError("Unable to get keyCode for: \(key)") }

    return keyCode
}

func send(fakeKey key: String, useCommandFlag: Bool) {
    let keyCode = stringToKeyCode(key)
    send(fakeKey: numericCast(keyCode), useCommandFlag: useCommandFlag)
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

