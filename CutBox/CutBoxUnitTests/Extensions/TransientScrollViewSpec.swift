//
//  TransientScrollViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 8/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import Quartz

class TransientScrollViewSpec: QuickSpec {

    private class MockResponder: NSResponder {
        var scrollWheelCalled = false

        override func scrollWheel(with event: NSEvent) {
            scrollWheelCalled = true
        }
    }

    override func spec() {
        describe("TransientScrollView") {
            var scrollView: TransientScrollView!
            var mockNextResponder: MockResponder!

            let wheelCount: UInt32 = 2
            let xScroll: Int32 = -1 // Negative for right
            let yScroll: Int32 = -2 // Negative for down

            let event = CGEvent(
                scrollWheelEvent2Source: nil,
                units: .pixel,
                wheelCount: wheelCount,
                wheel1: xScroll,
                wheel2: yScroll,
                wheel3: 0 // Additional wheel value, set to 0
            )!

            beforeEach {
                scrollView = TransientScrollView()
                mockNextResponder = MockResponder()
                scrollView.nextResponder = mockNextResponder
            }

            context("when isEnabled is true") {
                beforeEach {
                    scrollView.isEnabled = true
                }

                it("should handle scrollWheel events") {
                    if let theEvent = NSEvent(cgEvent: event) {
                        expect { scrollView.scrollWheel(with: theEvent) }.toNot(throwError())
                        // The next responder should not get the scroll wheel event
                        expect(mockNextResponder.scrollWheelCalled).to(beFalse())
                    } else {
                        fail("Failed to create NSEvent from CGEvent")
                    }
                }
            }

            context("when isEnabled is false") {
                beforeEach {
                    scrollView.isEnabled = false
                }

                it("should pass scrollWheel events to next responder") {
                    if let theEvent = NSEvent(cgEvent: event) {
                        expect { scrollView.scrollWheel(with: theEvent) }.toNot(throwError())
                        // The next responder should get the scroll wheel event
                        expect(mockNextResponder.scrollWheelCalled).to(beTrue())
                    } else {
                        fail("Failed to create NSEvent from CGEvent")
                    }
                }
            }
        }
    }
}
