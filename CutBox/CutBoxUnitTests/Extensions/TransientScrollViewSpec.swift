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
                    // Create a realistic CGEvent for scroll wheel
                    let wheelCount: UInt32 = 2
                    let xScroll: Int32 = -1 // Negative for right
                    let yScroll: Int32 = -2 // Negative for down

                    let event = CGEvent(
                        scrollWheelEvent2Source: nil,
                        units: .line,
                        wheelCount: wheelCount,
                        wheel1: xScroll,
                        wheel2: yScroll,
                        wheel3: 0 // Additional wheel value, set to 0
                    )!

                    // Create NSEvent from CGEvent
                    if let theEvent = NSEvent(cgEvent: event) {
                        expect { scrollView.scrollWheel(with: theEvent) }.toNot(throwError())

                        // Verify that the scrollWheel method of mockNextResponder was not called
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
                    // Create a realistic CGEvent for scroll wheel
                    let wheelCount: UInt32 = 2
                    let xScroll: Int32 = -1 // Negative for right
                    let yScroll: Int32 = -2 // Negative for down

                    let event = CGEvent(
                        scrollWheelEvent2Source: nil,
                        units: .line,
                        wheelCount: wheelCount,
                        wheel1: xScroll,
                        wheel2: yScroll,
                        wheel3: 0 // Additional wheel value, set to 0
                    )!

                    // Create NSEvent from CGEvent
                    if let theEvent = NSEvent(cgEvent: event) {
                        expect { scrollView.scrollWheel(with: theEvent) }.toNot(throwError())

                        // Verify that the scrollWheel method of mockNextResponder was called
                        expect(mockNextResponder.scrollWheelCalled).to(beTrue())
                    } else {
                        fail("Failed to create NSEvent from CGEvent")
                    }
                }
            }
        }
    }
}
