//
//  JSFuncServiceSpec.swift
//  CutBoxTests
//
//  Created by Jason on Sun May 27 2018 13:36:36 GMT+0800 (+08).
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import JavaScriptCore

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

                context("state persistence") {
                    it("shares a global JSContext during runtime") {
                        subject.repl("""
                                const a = 1
                                let b = 2
                                var c = 3
                                """)

                        subject.repl("""
                                a = 10
                                b = 1200
                                c = a + b
                                """)

                        if let result: [Int32] = subject.replValue("[a,b,c]")?
                            .toArray() as? [Int32] {
                            expect(result) == [1, 2, 3]
                        } else {
                            fail("JS repl not using shared JSContext")
                        }
                    }
                }
            }

            context("commands") {
                describe("[stdout,stderr] = shell(command: String, stdin: String? = nil)") {
                    it("runs a shell command and returns output to [stdout, stderr].") {
                        let result = subject
                            .repl("""
                                var [stdout, stderr] = shell(`
                                {
                                  echo "Hello stdout"
                                  echo "Hello stderr">&2
                                }
                                `);
                                // The output for .repl
                                `Out: ${stdout}\nErr: ${stderr}`;
                                """)
                        expect(result) == "Out: Hello stdout\n\nErr: Hello stderr\n"
                    }

                    it("runs a shell command with input from stdin") {
                        let result = subject.repl("""
                        let [out, err] = shell(`cat`, "Foo Foo Foo")
                        out
                        """)
                        expect(result) == "Foo Foo Foo"
                    }
                }

                describe("stdout = shellCommand(command)") {
                    it("runs a shell command from JS and returns a string") {
                        let result = subject.repl("shellCommand('printf \"hello world\"')")
                        expect(result).to(equal("hello world"))
                    }
                }

                describe("require") {
                    let fileManager = FileManager.default
                    let path = "\(fileManager.currentDirectoryPath)/test-require.js"

                    context("require a missing file") {
                        it("returns undefined") {
                            let result = subject.repl("require('test.js')")
                            expect(result) == "undefined"
                        }
                    }

                    context("require a unreadable file") {
                        it("returns undefined") {
                            let result = subject.repl("require('/')")
                            expect(result) == "undefined"
                        }
                    }

                    context("require an existing file") {
                        func createTestFile(path: String, contents: String) {
                            fileManager.createFile(
                                atPath: path,
                                contents: contents.data(using: .utf8))
                        }

                        beforeEach {
                            createTestFile(path: path, contents: "10 * 10")
                        }

                        afterEach {
                            try? fileManager.removeItem(atPath: path)
                        }

                        it("evaluates the file as JS") {
                            let result = subject.repl("require(\"\(path)\");")

                            expect(result) == "100"
                        }

                        context("using a required library") {
                            it("evaluates the file as JS") {
                                createTestFile(path: path, contents: """
                                let foobar = {
                                    fn: (i) => `Hello ${i}!`
                                }
                                """)
                                subject.repl("require(\"\(path)\");")
                                let result = subject.repl("foobar.fn(`Tuesday`)")
                                expect(result) == "Hello Tuesday!"
                            }
                        }
                    }
                }
            }

            describe("isEmpty") {
                it("true when no functions are loaded") {
                    subject.repl("this.cutboxFunctions = null")
                    expect(subject.isEmpty) == true
                }
            }

            describe("count") {
                it("return the count of functions in cutboxFunctions") {
                    _ = subject.repl(
                        """
                        this.cutboxFunctions = []
                        this.cutboxFunctions.push({name: \"Test\", fn: i => \"done\" })
                        """
                    )
                    expect(subject.count) == 1
                }
            }

            describe("list") {
                beforeEach {
                    _ = subject.repl(
                        """
                        this.cutboxFunctions = []
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

                describe("funcList") {
                    context("no filter") {
                        it("returns a list of function names in cutboxFunctions") {
                            expect(subject.funcList).to(equal(["Test", "Another"]))
                        }
                    }

                    describe("with filterText") {
                        it("set a text filter on the function names in cutboxFunctions") {
                            subject.filterText = "no"

                            expect(subject.funcList) == ["Another"]
                        }
                    }

                    context("invalid cutboxFunctions") {

                        beforeEach {
                            _ = subject.repl("this.cutboxFunctions = {foobar: 23}")
                        }

                        it("does not list any functions") {
                            expect(subject.funcList) == []
                        }

                        it("does not filter") {
                            subject.filterText = "foobar"
                            expect(subject.funcs.count) == 0
                        }
                    }
                }

                describe("selected") {
                    it("returns the index of the selected func by name") {
                        let index = subject.selected(name: "Another")!

                        expect(index.1).to(equal(1))
                    }
                }

                describe("funcs") {
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
