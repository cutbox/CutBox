//
//  CommandParamsTests.swift
//  
//  Created by jason on 30/8/23.
//

import Quick
import Nimble

@testable import CutBoxCLICore
import Foundation

class CommandParamsSpec: QuickSpec {
    override func spec() {
        var subject: CommandParams!

        beforeEach {
            subject = CommandParams(out: MockOutput(), arguments: [])
        }

        describe("hasOption function") {
            it("should return the specified value for String type") {
                subject.arguments  = ["-opt", "stringValue"]

                let result: String? = subject.hasOption("-opt")
                expect(result).to(equal("stringValue"))
            }

            it("should return the specified value for Int type") {
                subject.arguments  = ["-opt", "42"]

                let result: Int? = subject.hasOption("-opt")
                expect(result).to(equal(42))
            }

            it("should return the specified value for Double type") {
                subject.arguments = ["-opt", "3.14"]

                let result: Double? = subject.hasOption("-opt")
                expect(result).to(beCloseTo(3.14))
            }

            it("should return nil if option is not present") {
                subject.arguments  = ["--otherOpt", "value"]

                let result: String? = subject.hasOption("--opt")
                expect(result).to(beNil())
            }

            it("should return nil if option value starts with '--'") {
                subject.arguments  = ["--opt", "--invalidValue"]

                let result: String? = subject.hasOption("--opt")
                expect(result).to(beNil())
            }

            it("will throw a fatalError if the return type is not String, Int or Double") {
                subject.arguments  = ["--opt", ""]
                expect { subject.hasOption("--opt") }.to(throwAssertion())
            }
        }

        describe("timeOption") {
            it("reads a time option and checks existing arguments") {
                subject.arguments = ["--since", "1 day"]
                let time = Date().timeIntervalSince1970 - 86400.0
                let result = subject.timeOption("--since")

                expect(result).to(beCloseTo(time, within: 1.5))
            }

            it("returns nil for an invalid time value") {
                subject.arguments = ["--since", "Oi Billy"]
                let result = subject.timeOption("--since")

                expect(result).to(beNil())
            }
        }

        describe("parseSeconds") {
            context("tiny time language") {
                for unit in [
                    ("s", 1.0),
                    ("sec", 1.0),
                    ("secs", 1.0),
                    ("m", 60.0),
                    ("min", 60.0),
                    ("mins", 60.0),
                    ("h", 3600.0),
                    ("hr", 3600.0),
                    ("hrs", 3600.0),
                    ("d", 86400.0),
                    ("day", 86400.0),
                    ("days", 86400.0),
                    ("w", 604800.0),
                    ("wk", 604800.0),
                    ("week", 604800.0),
                    ("weeks", 604800.0)
                ] {
                    for value in [
                        1.0,
                        3.0,
                        5.0,
                        7.0
                    ] {
                        it("parses \(Int(value)) \(unit.0)") {
                            expect(subject.parseToSeconds("\(Int(value)) \(unit.0)")) == unit.1 * value
                        }
                    }
                }
            }
        }

        describe("collectErrors") {
            context("after parsing, arguments left over are errors") {
                it("collects remaining arguments") {
                    let arguments = ["-o0", "value1",
                                     "-o1", "value2",
                                     "--opt3",
                                     "--opt4", "value2"]
                    subject.collectErrors(arguments)

                    expect(subject.errors.count) == 4
                    expect(subject.errors[0]) == ("-o0", "value1")
                    expect(subject.errors[1]) == ("-o1", "value2")
                    expect(subject.errors[2]) == ("--opt3", "")
                    expect(subject.errors[3]) == ("--opt4", "value2")
                }
            }
        }
    }
}
