//
//  TransientScrollViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 18/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class TransientScrollViewSpec: QuickSpec {
    override func spec() {
        describe("TransientScrollView") {
            let subject = TransientScrollView()
            let cgEvent = CGEvent(
                scrollWheelEvent2Source: nil,
                units: .line,
                wheelCount: 1,
                wheel1: 10,
                wheel2: 0,
                wheel3: 0)
            let scrollEvent = NSEvent(cgEvent: cgEvent!)

            it("can become first responder") {
                expect(subject.becomeFirstResponder()).to(beTrue())
            }

            it("should handle scrolling when enabled") {
                subject.isEnabled = true
                subject.scrollWheel(with: scrollEvent!)
            }

            it("should pass scroll events to the next responder when disabled") {
                subject.isEnabled = false
                subject.scrollWheel(with: scrollEvent!)
            }
        }
    }
}
