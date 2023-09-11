//
//  CutBoxBaseTextViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 11/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import Carbon

class ExampleTextView: CutBoxBaseTextView {}

class CutBoxBaseTextViewSpec: QuickSpec {
    override func spec() {
        describe("CutBoxBaseTextView") {
            context("init") {
                it("should init from frame and textContainer") {
                    let example = ExampleTextView(
                        frame: .zero,
                        textContainer: nil)
                    expect(example.initFrameWasCalled).to(beTrue())
                }

                it("should init from coder") {
                    let instance = ExampleView(frame: .zero)
                    let coder = mockCoder(for: instance)
                    let example = ExampleTextView(coder: coder!)
                    expect(example?.initCoderWasCalled).to(beTrue())
                }
            }

            context("keyDown") {
                it("should call key down") {
                    let example = ExampleTextView(
                        frame: .zero,
                        textContainer: nil)
                    example.keyDown(with: nil)
                    expect(example.keyDownWasCalled).to(beTrue())
                }
            }

            context("doCommand") {
                it("should call doCommand") {
                    let example = ExampleTextView(
                        frame: .zero,
                        textContainer: nil)
                    example.doCommand(by: nil)
                    expect(example.doCommandWasCalled).to(beTrue())
                }
            }
        }
    }
}
