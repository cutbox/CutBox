//
//  HistoryLimitNumberFormatterSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 14/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class HistoryLimitNumberFormatterSpec: QuickSpec {
    override func spec() {
        describe("HistoryLimitNumberFormatter") {
            var formatter: HistoryLimitNumberFormatter!

            beforeEach {
                formatter = HistoryLimitNumberFormatter()
            }

            context("isPartialStringValidationEnabled") {
                it("should return true") {
                    expect(formatter.isPartialStringValidationEnabled).to(beTrue())
                }

                it("should not be settable") {
                    expect { formatter.isPartialStringValidationEnabled = false }.to(throwAssertion())
                }
            }

            context("intOnlyRegex") {
                it("should not be nil") {
                    expect(formatter.intOnlyRegex).toNot(beNil())
                }
            }

            context("isPartialStringValid") {
                it("should return true for valid integer input") {
                    let input = "123"
                    var newString: NSString?
                    var error: NSString?
                    let isValid = formatter.isPartialStringValid(input,
                                                                 newEditingString: &newString,
                                                                 errorDescription: &error)

                    expect(isValid).to(beTrue())
                    expect(error).to(beNil())
                }

                it("should return false for non-integer input") {
                    let input = "abc"
                    var newString: NSString?
                    var error: NSString?
                    let isValid = formatter.isPartialStringValid(input,
                                                                 newEditingString: &newString,
                                                                 errorDescription: &error)

                    expect(isValid).to(beFalse())
                }

                it("should return false for mixed input") {
                    let input = "123abc"
                    var newString: NSString?
                    var error: NSString?
                    let isValid = formatter.isPartialStringValid(input,
                                                                 newEditingString: &newString,
                                                                 errorDescription: &error)

                    expect(isValid).to(beFalse())
                }
            }
        }
    }
}
