//
//  JSFuncServiceSpec.swift
//  CutBoxTests
//
//  Created by Jason on Sun May 27 2018 13:36:36 GMT+0800 (+08).
//  Copyright © 2018 ocodo. All rights reserved.
//

import Quick
import Nimble

@testable import CutBox

class JSFuncServiceSpec: QuickSpec {

    override func spec() {
        var subject: JSFuncService!

        describe("JSFuncService") {
            beforeEach {
                subject = JSFuncService()
                subject.setup()
            }

            describe("repl") {
                it("processes through JS and returns a string") {
                    let result = subject.repl("123 + 123")
                    expect(result).to(equal("246"))
                }
            }

            describe("require") {
                let fileManager = FileManager.default
                let path = "\(fileManager.currentDirectoryPath)/test-require.js"

                beforeEach {
                    fileManager.createFile(
                        atPath: path,
                        contents: "10 * 10"
                            .data(using: .utf8)
                    )
                }

                afterEach {
                    // swiftlint:disable force_try
                    try! fileManager.removeItem(atPath: path)
                    // swiftlint:enable force_try
                }

                it("evaluates the file as JS") {
                    let result = subject.repl("require(\"\(path)\");")

                    expect(result).to(equal("100"))
                }
            }

            describe("count") {
                it("return the count of functions in cutboxFunctions") {
                    _ = subject.repl(
                        """
                        this.cutboxFunctions = this.cutboxFunctions || []
                        this.cutboxFunctions.push({name: \"Test\", fn: i => \"done\" })
                        """
                    )
                    expect(subject.count).to(equal(1))
                }
            }

            describe("list") {

                beforeEach {
                    _ = subject.repl(
                        """
                        this.cutboxFunctions = this.cutboxFunctions || []
                        this.cutboxFunctions.push({name: \"Test\", fn: i => \"done\" })
                        """
                    )

                    _ = subject.repl(
                        """
                        this.cutboxFunctions = this.cutboxFunctions || []
                        this.cutboxFunctions.push({name: \"Another\", fn: i => \"done\" })
                        """
                    )
                }

                context("no filter") {
                    it("returns a list of function names in cutboxFunctions") {
                        expect(subject.funcList).to(equal(["Test", "Another"]))
                    }
                }

                context("filtered") {
                    it("returns a filtered list of function names in cutboxFunctions") {
                        subject.filterText = "no"

                        expect(subject.funcList).to(equal(["Another"]))
                    }
                }

                context("selected") {
                    it("returns the index of the selected func by name") {
                        let index = subject.selected(name: "Another")!

                        expect(index.1).to(equal(1))
                    }
                }

                context("funcs") {
                    it("returns the unfiltered function name/index list for lookup") {
                        subject.filterText = "no"

                        let actual: [(String, Int)] = subject.funcs
                        let names = actual.map { $0.0 }
                        let indecies = actual.map { $0.1 }

                        expect(names).to(equal(["Test", "Another"]))
                        expect(indecies).to(equal([0, 1]))
                    }
                }
            }
        }
    }

}
