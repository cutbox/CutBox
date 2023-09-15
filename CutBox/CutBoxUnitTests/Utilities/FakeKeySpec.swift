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
                fakeKey.testing = true
                fakeKey.send(fakeKey: "A", useCommandFlag: true)

                expect(fakeKey.testResult.count).to(equal(2))

                let keyDownEvent = fakeKey.testResult[0]
                let keyUpEvent = fakeKey.testResult[1]

                expect(keyDownEvent).toNot(beNil())
                expect(keyUpEvent).toNot(beNil())

                // Check if the command flag is set
                expect(keyDownEvent?.flags.contains(.maskCommand)).to(beTrue())
            }

            it("creates events for alpha key code with no modifier") {
                fakeKey.testing = true
                fakeKey.send(fakeKey: "B", useCommandFlag: false)

                expect(fakeKey.testResult.count).to(equal(2))

                let keyDownEvent = fakeKey.testResult[0]
                let keyUpEvent = fakeKey.testResult[1]

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