//
//  FakeKeySpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 14/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import Carbon

func fakeKeyEvent(_ keyCode: Int, _ modifierFlags: NSEvent.ModifierFlags = []) -> Any {
    if let event: NSEvent = fakeKey(keyCode, modifierFlags) {
        return event as Any
    } else {
        fatalError("Could not make NSEvent")
    }
}

func fakeKey(_ keyCode: Int, _ modifierFlags: NSEvent.ModifierFlags = []) -> NSEvent? {
    NSEvent.keyEvent(with: .keyDown,
                     location: .zero,
                     modifierFlags: modifierFlags,
                     timestamp: 0.0,
                     windowNumber: 1,
                     context: nil,
                     characters: "",
                     charactersIgnoringModifiers: "",
                     isARepeat: false,
                     keyCode: UInt16(keyCode))
}

class FakeKeySpec: QuickSpec {
    override func spec() {
        describe("FakeKey") {
            var fakeKey: FakeKey!

            beforeEach {
                fakeKey = FakeKey()
            }

            afterEach {
                fakeKey = nil
            }

            it("creates events for alpha key code with command modifier") {
                FakeKey.testing = true
                fakeKey.send(fakeKey: "A", useCommandFlag: true)

                expect(FakeKey.testResult.count).to(equal(2))

                let keyDownEvent = FakeKey.testResult[0]
                let keyUpEvent = FakeKey.testResult[1]

                expect(keyDownEvent).toNot(beNil())
                expect(keyUpEvent).toNot(beNil())

                // Check if the command flag is set
                expect(keyDownEvent?.flags.contains(.maskCommand)).to(beTrue())
            }

            it("creates events for alpha key code with no modifier") {
                FakeKey.testing = true
                FakeKey.testResult = []
                fakeKey.send(fakeKey: "B", useCommandFlag: false)

                expect(FakeKey.testResult.count).to(equal(2))

                let keyDownEvent = FakeKey.testResult[0]
                let keyUpEvent = FakeKey.testResult[1]

                expect(keyDownEvent).toNot(beNil())
                expect(keyUpEvent).toNot(beNil())

                // Check if the command flag is NOT set
                expect(keyDownEvent?.flags.contains(.maskCommand)).to(beFalse())
            }

            it("raises an error for invalid key code (more than 1 char)") {
                expect {
                    fakeKey.send(fakeKey: "AB", useCommandFlag: false)
                }.to(throwAssertion())
            }
        }
    }
}
