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
            var popupController: PopupController!
            var mockContent: CutBoxBaseView!

            beforeEach {
                mockContent = CutBoxBaseView()
                popupController = PopupController(content: mockContent)
            }

            context("when opening the popup") {
                it("should set isOpen to true") {
                    popupController.openPopup()
                    expect(popupController.isOpen) == true
                }

                it("should make the content view visible") {
                    popupController.openPopup()
                    expect(popupController.contentView.isHidden) == false
                }
            }

            context("when closing the popup") {
                it("should set isOpen to false") {
                    popupController.closePopup()
                    expect(popupController.isOpen) == false
                }

                it("should hide the content view") {
                    popupController.closePopup()
                    expect(popupController.contentView.isHidden) == true
                }
            }

            context("when toggling the popup") {
                it("should open the popup if it's closed") {
                    popupController.isOpen = false
                    popupController.togglePopup()
                    expect(popupController.isOpen) == true
                }

                it("should close the popup if it's open") {
                    popupController.isOpen = true
                    popupController.togglePopup()
                    expect(popupController.isOpen) == false
                }
            }
        }
    }
}
