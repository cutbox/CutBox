//
//  AboutPanelSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 8/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

import Quick
import Nimble

class AboutPanelSpec: QuickSpec {
    override func spec() {
        describe("AboutPanel") {
            var aboutPanel: AboutPanel!

            beforeEach {
                aboutPanel = AboutPanel.fromNib()
            }

            it("should have a transparent titlebar") {
                expect(aboutPanel.titlebarAppearsTransparent).to(beTrue())
            }

            it("should set the product version correctly") {
                let expectedVersion = VersionService.version // You may need to replace this with the actual version.
                expect(aboutPanel.productVersion.stringValue).to(equal(expectedVersion))
            }

            it("should set the product title correctly") {
                let expectedTitle = "about_cutbox_title".l7n // Replace with the expected title value.
                expect(aboutPanel.productTitle.stringValue).to(equal(expectedTitle))
            }

            it("should set the product license correctly") {
                let expectedLicense = "about_cutbox_copyright_licence".l7n // Replace with the expected license text.
                expect(aboutPanel.productLicense.stringValue).to(equal(expectedLicense))
            }
        }
    }
}
