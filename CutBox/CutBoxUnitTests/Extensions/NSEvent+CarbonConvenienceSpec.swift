//
//  NSEvent+CarbonConvenienceSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 6/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class NSEvent_CarbonConvenienceSpec: QuickSpec {
    override func spec() {
        describe("NSEvent") {
            let subject = NSEvent.keyEvent(with: .keyDown,
                                           location: .zero,
                                           modifierFlags: [.command],
                                           timestamp: 0.0,
                                           windowNumber: 1,
                                           context: nil,
                                           characters: "",
                                           charactersIgnoringModifiers: "",
                                           isARepeat: false,
                                           keyCode: 48)

            describe("key") {
                expect(subject?.key) == Int(48)
            }

            describe("modifiers") {
                expect(subject?.modifiers) == [.command]
            }
        }
    }
}
