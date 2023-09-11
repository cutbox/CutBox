//
//  CutBoxBaseViewControllerSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 11/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class ExampleViewController: CutBoxBaseViewController {}

class CutBoxBaseViewControllerSpec: QuickSpec {
    override func spec() {
        describe("CutBoxBaseViewController") {
            it("should init with coder") {
                let example = ExampleViewController(coder: mockCoder(for: NSViewController())!)
                expect(example?.initCoderWasCalled).to(beTrue())
            }

            it("should init with params") {
                let example = ExampleViewController(nibName: nil, bundle: nil)
                expect(example.initWithParamsWasCalled).to(beTrue())
            }
        }
    }
}
