//
//  CutBoxBaseViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 11/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation
import Quick
import Nimble

class ExampleView: CutBoxBaseView {}

class CutBoxBaseViewSpec: QuickSpec {
    override func spec() {
        describe("CutBoxBaseView") {
            context("init") {
                it("shold init with coder") {
                    let object = ExampleView()
                    let example = ExampleView(coder: mockCoder(for: object)!)
                    expect(example?.initCoderWasCalled).to(beTrue())
                }

                it("should init from frame") {
                    let example = ExampleView(frame: .zero)
                    expect(example.initFrameWasCalled).to(beTrue())
                }

                it("should awake from nib") {
                    let instance = ExampleView(frame: .zero)
                    instance.awakeFromNib()

                    expect(instance.awakeFromNibWasCalled).to(beTrue())
                }
            }
        }
    }
}
