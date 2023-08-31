//
//  CommandParamsTests.swift
//  
//  Created by jason on 30/8/23.
//

import Quick
import Nimble

@testable import CutBoxCLICore

class CommandParamsSpec: QuickSpec {
    override func spec() {
        var subject: CommandParams!

        beforeEach {
            subject = CommandParams(out: MockOutput(), arguments: [])
        }

        describe("hasOpt function") {
            it("should return the specified value for String type") {
                subject.arguments  = ["programName", "-opt", "stringValue"]

                let result: String? = subject.hasOpt("-opt")
                expect(result).to(equal("stringValue"))
            }

            it("should return the specified value for Int type") {
                subject.arguments  = ["programName", "-opt", "42"]

                let result: Int? = subject.hasOpt("-opt")
                expect(result).to(equal(42))
            }

            it("should return the specified value for Double type") {
                subject.arguments = ["programName", "-opt", "3.14"]

                let result: Double? = subject.hasOpt("-opt")
                expect(result).to(beCloseTo(3.14))
            }

            it("should return nil if option is not present") {
                subject.arguments  = ["--otherOpt", "value"]

                let result: String? = subject.hasOpt("--opt")
                expect(result).to(beNil())
            }

            it("should return nil if option value starts with '--'") {
                subject.arguments  = ["--opt", "--invalidValue"]

                let result: String? = subject.hasOpt("--opt")
                expect(result).to(beNil())
            }
        }

        context("after parsing, arguments left over are errors") {
            describe("collectErrors") {
                it("collects remaining arguments") {
                    let arguments = ["-o0", "value1",
                                     "-o1", "value2",
                                     "--opt2",
                                     "--opt3", "value2"]
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
