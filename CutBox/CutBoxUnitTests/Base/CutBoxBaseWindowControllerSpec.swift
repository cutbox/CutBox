//
//  CutBoxBaseWindowControllerSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 11/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class ExampleWindowController: CutBoxBaseWindowController {}

class CutBoxBaseWindowControllerSpec: QuickSpec {
    override func spec() {
        describe("CutBoxBaseWindowController") {
            context("wraps NSWindowController") {
                it("should monitor init coder calls") {
                    let object = NSWindowController()
                    let example = ExampleWindowController(coder: mockCoder(for: object)!)!
                    expect(example.initCoderWasCalled).to(beTrue())
                }

                it("should monitor init window calls") {
                    let window = NSWindow()
                    let example = ExampleWindowController(window: window)
                    expect(example.initWindowWasCalled).to(beTrue())
                }
            }
        }
    }
}
