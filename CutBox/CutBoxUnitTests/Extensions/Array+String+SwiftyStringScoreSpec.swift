//
//  Array+String+SwiftyStringScoreSpec.swift
//  CutBoxTests
//
//  Created by Jason on 12/4/18.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class ArrayStringSwiftyStringScoreSpec: QuickSpec {
    override func spec() {
        describe("Array+String+SwiftyStringScore") {
            context("on historyStore") {
                var subject: [[String: String]]!

                beforeEach {
                    subject = [
                        ["string": "Foo bar"],
                        ["string": "Fizz Buzz"],
                        ["string": "Bob the Hoojah Melon", "favorite": "favorite"],
                        ["string": "JR Bob Dobbs"],
                        ["string": "Relatively complicated and doesn't fuzzy match with anything else"],
                        ["string": "Generic code sample"],
                        ["string": "Boustrophedon"],
                        ["string": "Bobby"],
                        ["string": "Robobt"],
                        ["string": "Unexpectation analogy"],
                        ["string": "Boost boost"],
                        ["string": "39124741"],
                        ["string": "FF443211"],
                        ["string": "Bob"],
                        ["string": "#ff11ab"],
                        ["string": "#FF0022"],
                        ["string": "Example"],
                        ["string": "We couldn’t reveal your PIN. Let’s give this another go."]
                    ]
                }

                it("filters by fuzzy search") {
                    let fuzzySearch = "Bob"
                    let result = subject.fuzzySearchRankedFiltered(search: fuzzySearch,
                                                                    score: 0.5)
                    let expectation = [
                        ["string": "Bob"],
                        ["string": "Bobby"],
                        ["string": "Boost boost"],
                        ["string": "Bob the Hoojah Melon", "favorite": "favorite"],
                        ["string": "JR Bob Dobbs"]
                    ]

                    expect(expectation) == result
                }

                context("regex filter") {
                    it("returns an empty array for a non-matching regex") {
                        let patternNoMatch = ".*How.*"
                        let result = subject.regexpSearchFiltered(search: patternNoMatch,
                                                                  options: .caseInsensitive)
                        let expectation: [[String: String]] = []

                        expect(result) == expectation
                    }

                    it("returns an empty array for an invalid regex") {
                        let patternNoMatch = ".*[wait I wasn't (finished.*"
                        let result = subject.regexpSearchFiltered(search: patternNoMatch,
                                                                  options: .caseInsensitive)
                        let expectation: [[String: String]] = []

                        expect(result) == expectation
                    }

                    it("filters by regexp") {
                        let pattern = "Bo.*"
                        let result = subject
                            .regexpSearchFiltered(
                                search: pattern,
                                options: .caseInsensitive
                            )

                        let expectation = [
                            ["string": "Bob the Hoojah Melon", "favorite": "favorite"],
                            ["string": "JR Bob Dobbs"],
                            ["string": "Boustrophedon"],
                            ["string": "Bobby"],
                            ["string": "Robobt"],
                            ["string": "Boost boost"],
                            ["string": "Bob"]
                        ]

                        expect(result) == expectation
                    }
                }

                context("substring") {
                    it("does not crash with on invalid dict entries") {
                        let substring = "Get it"
                        subject = [
                            ["srting": "Get it"],
                            ["string": "Get it"],
                            ["string": "Got it"]
                        ]
                        let expectation = [["string": "Get it"]]
                        let result = subject.substringSearchFiltered(search: substring)

                        expect(result) == expectation
                    }

                    it("returns an empty array if the substring is not matched") {
                        let substring = "Quaint"
                        let result = subject.substringSearchFiltered(search: substring)
                        let expectation: [[String: String]] = []

                        expect(result) == expectation
                    }

                    it("filters by substring") {
                        let substring = "PIN."
                        let expectation = [
                            ["string": "We couldn’t reveal your PIN. Let’s give this another go."]
                        ]
                        let result = subject.substringSearchFiltered(search: substring)

                        expect(result) == expectation
                    }
                }
            }

            context("on array of String") {
                let subject = [
                    "Foo bar",
                    "Fizz Buzz",
                    "Bob the Hoojah Melon",
                    "JR Bob Dobbs",
                    "Relatively complicated and doesn't fuzzy match with anything else",
                    "Generic code sample",
                    "Boustrophedon",
                    "Bobby",
                    "Robobt",
                    "Unexpectation analogy",
                    "Boost boost",
                    "39124741",
                    "FF443211",
                    "Bob",
                    "#ff11ab",
                    "#FF0022",
                    "Example",
                    "We couldn’t reveal your PIN. Let’s give this another go."
                ]

                context("fuzzy match") {
                    it("filters and ranks an array using search string") {
                        let fuzzySearch = "Bob"
                        let result = subject.fuzzySearchRankedFiltered(search: fuzzySearch,
                                                                       score: 0.5)
                        let expectation = ["Bob",
                                           "Bobby",
                                           "Boost boost",
                                           "Bob the Hoojah Melon",
                                           "JR Bob Dobbs"]

                        expect(result) == expectation
                    }
                }

                context("substring") {
                    it("returns an empty array if the substring is not matched") {
                        let substring = "Quaint"
                        let result = subject.substringSearchFiltered(search: substring)
                        let expectation: [String] = []

                        expect(result) == expectation
                    }

                    it("filters by substring") {
                        let substring = "PIN."
                        let expectation = [
                            "We couldn’t reveal your PIN. Let’s give this another go."
                        ]
                        let result = subject.substringSearchFiltered(search: substring)

                        expect(result) == expectation
                    }
                }

                context("regex") {
                    it("returns an empty array for a non-matching regex") {
                        let patternNoMatch = ".*How.*"
                        let result = subject.regexpSearchFiltered(search: patternNoMatch,
                                                                  options: .caseInsensitive)
                        let expectation: [String] = []

                        expect(result) == expectation
                    }

                    it("returns an empty array for an invalid regex") {
                        let patternNoMatch = ".*[wait I wasn't (finished.*"
                        let result = subject.regexpSearchFiltered(search: patternNoMatch,
                                                                  options: .caseInsensitive)
                        let expectation: [String] = []

                        expect(result) == expectation
                    }
                }
            }
        }
    }
}
