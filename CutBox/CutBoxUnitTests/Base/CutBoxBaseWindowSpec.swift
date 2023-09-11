//
//  CutBoxBaseWindowSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 11/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class ExampleWindow: CutBoxBaseWindow {}

class CutBoxBaseWindowSpec: QuickSpec {
    override func spec() {
        describe("CutBoxBaseWindow") {
            it("should init with params") {
                let window = ExampleWindow(
                    contentRect: .zero,
                    styleMask: .titled,
                    backing: .buffered,
                    defer: false)
                expect(window.initWithParamsCalled).to(beTrue())
            }
        }
    }
}
