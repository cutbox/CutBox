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
                subject.arguments  = ["programName", "-otherOpt", "value"]

                let result: String? = subject.hasOpt("-opt")
                expect(result).to(beNil())
            }

            it("should return nil if option value starts with '-'") {
                subject.arguments  = ["programName", "-opt", "-invalidValue"]

                let result: String? = subject.hasOpt("-opt")
                expect(result).to(beNil())
            }
        }
    }
}
