//
//  TimeFilterValidatorSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 13/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation
import Quick
import Nimble

class TimeFilterValidatorSpec: QuickSpec {
    override func spec() {
        describe("TimeFilterValidator") {
            describe("secondsToTime") {
                let values = [
                    (inputValue: 1230, expectedResult: "20 minutes 30 seconds"),
                    (inputValue: 60, expectedResult: "1 minute"),
                    (inputValue: 61, expectedResult: "1 minute 1 second"),
                    (inputValue: 90, expectedResult: "1 minute 30 seconds"),
                    (inputValue: 110, expectedResult: "1 minute 50 seconds"),
                    (inputValue: 3610, expectedResult: "1 hour 10 seconds"),
                    (inputValue: 3780, expectedResult: "1 hour 3 minutes"),
                    (inputValue: 86400, expectedResult: "1 day"),
                    (inputValue: 86461, expectedResult: "1 day 1 minute 1 second"),
                    (inputValue: 604800, expectedResult: "1 week")
                ]

                for (inputValue, expectedResult) in values {
                    it("formats \(inputValue) to \(expectedResult)") {
                        let timeString = TimeFilterValidator
                            .secondsToTime(seconds: inputValue)
                        
                        expect(timeString).to(equal(expectedResult))
                    }
                }
            }

            it("validates time filter strings") {
                let value = "10 min"
                let subject = TimeFilterValidator(value: value)
                expect(subject.isValid).to(beTrue())
            }

            it("invalidates malformed time filter strings") {
                let value = "10 mice"
                let subject = TimeFilterValidator(value: value)
                expect(subject.isValid).to(beFalse())
            }

            describe("validates multiple time units") {
                let values = [
                    // Seconds
                    "10.41 s", "10.12130 sec", "91.1 secs", "23.1134 seconds", "10.149 second",
                    "10.85s", "10.12130sec", "91.1secs", "23.1134seconds", "10.149second",
                    "10 s", "10 sec", "91 secs", "23 seconds", "10 second",
                    "10s", "100sec", "91secs", "23seconds", "10second",

                    // Minutes
                    "10.41 m", "10.12130 min", "91.1 minutes", "23.1134 mins", "10.149 minute",
                    "10.85m", "10.12130min", "91.1minutes", "23.1134mins", "10.149minute",
                    "10 m", "10 min", "91 minutes", "23 mins", "10 minute",
                    "10m", "100min", "91minutes", "23mins", "10minute",

                    // Hours
                    "10.41 h", "10.12130 hr", "91.1 hours", "23.1134 hrs", "10.149 hour",
                    "10.85h", "10.12130hr", "91.1hours", "23.1134hrs", "10.149hour",
                    "10 h", "10 hr", "91 hours", "23 hrs", "10 hour",
                    "10h", "100hr", "91hours", "23hrs", "10hour",

                    // Days
                    "10.41 d", "10.12130 day", "91.1 days", "23.1134 days", "10.149 day",
                    "10.85d", "10.12130day", "91.1days", "23.1134days", "10.149day",
                    "10 d", "10 day", "91 days", "23 days", "10 day",
                    "10d", "100day", "91days", "23days", "10day",

                    // Weeks
                    "10.41 w", "10.12130 wk", "91.1 weeks", "23.1134 wks", "10.149 week",
                    "10.85w", "10.12130wk", "91.1wks", "23.1134wks", "10.149week",
                    "10 w", "10 wk", "91 weeks", "23 wks", "10 week",
                    "10w", "100wk", "91wks", "23wks", "10week"
                ]

                for value in values {
                    it("validates \(value) correctly") {
                        let subject = TimeFilterValidator(value: value)

                        //debug: print("\(value) is valid: \(subject.isValid)")
                        expect(subject.isValid).to(beTrue())
                    }
                }
            }
        }
    }
}
