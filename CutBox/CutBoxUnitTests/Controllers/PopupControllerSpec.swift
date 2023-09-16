//
//  PopupControllerSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 16/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class PopupControllerSpec: QuickSpec {
    override func spec() {
        describe("PopupController") {
            var subject: PopupController!
            var mockContent: CutBoxBaseView!

            beforeEach {
                mockContent = CutBoxBaseView()
                subject = PopupController(content: mockContent)
            }

            context("init coder") {
                it("initializes with a coded view") {
                    let instance = ExampleView(frame: .zero)
                    let coder = mockCoder(for: instance)
                    expect {
                        PopupController(coder: coder!)
                    }.toNot(throwAssertion())
                }
            }

            context("resizing") {
                it("resizes width") {
                    subject.resizePopup(width: 600)
                    expect(subject.currentWidth) == 600
                }
                it("resizes height") {
                    subject.resizePopup(height: 600)
                    expect(subject.currentHeight) == 600
                }

                it("proportionally resizes") {
                    let mockScreenFrame = NSRect(
                        x: 0, y: 0,
                        width: 90, height: 70
                    )

                    let mockScreen = MockScreen(frame: mockScreenFrame)

                    NSScreenMockScreen = mockScreen
                    NSScreenTesting = true

                    subject.resizePopup(width: 1000, height: 1600)

                    expect(subject.currentWidth) == 1000
                    subject.proportionalResizePopup()
                    expect(subject.currentWidth) == 56.25

                    subject.contentInset = 5.0
                    expect(subject.contentInset) == 5.0
                }
            }

            context("when opening the popup") {
                it("should set isOpen to true") {
                    subject.openPopup()
                    expect(subject.isOpen) == true
                }

                it("should make the content view visible") {
                    subject.openPopup()
                    expect(subject.contentView.isHidden) == false
                }
            }

            context("when closing the popup") {
                it("should set isOpen to false") {
                    subject.closePopup()
                    expect(subject.isOpen) == false
                }

                it("should hide the content view") {
                    subject.closePopup()
                    expect(subject.contentView.isHidden) == true
                }
            }

            context("when toggling the popup") {
                it("should open the popup if it's closed") {
                    subject.isOpen = false
                    subject.togglePopup()
                    expect(subject.isOpen) == true
                }

                it("should close the popup if it's open") {
                    subject.isOpen = true
                    subject.togglePopup()
                    expect(subject.isOpen) == false
                }
            }
        }
    }
}
