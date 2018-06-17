//
//  HistoryRepoSpec.swift
//  CutBoxTests
//
//  Created by Jason on 29/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

import Quick
import Nimble

@testable import CutBox

class HistoryRepoSpec: QuickSpec {

    override func spec() {
        describe("HistoryRepo") {
            var subject: HistoryRepo!
            var defaults: UserDefaults!

            beforeEach {
                defaults = UserDefaultsMock()

                subject = HistoryRepo(defaults: defaults)
            }

            it("can insert string items and provide them as an array") {
                subject.insert("Hello")
                expect(subject.items).to(contain("Hello"))
            }

            it("provides access to the dictionary store") {
                subject.insert("Hello")
                expect(subject.dict.first).to(equal(["string": "Hello"]))
            }

            it("returns string items in the expected order") {
                subject.insert("First")
                subject.insert("Second")
                subject.insert("Third")
                expect(subject.items).to(equal([
                    "Third",
                    "Second",
                    "First"
                    ]))
            }

            it("can remove string items at a given index") {
                subject.insert("First")
                subject.insert("Second")
                subject.insert("Third")

                subject.remove(at: 1)

                expect(subject.items).to(equal([
                    "Third",
                    "First"
                    ]))
            }

            it("can remove string items at a given IndexSet") {
                subject.insert("First")
                subject.insert("Second")
                subject.insert("Third")

                subject.removeAtIndexes(indexes: [0, 2])

                expect(subject.items).to(equal([
                    "Second"
                    ]))
            }

            it("can remove string items in a given subrange") {
                subject.insert("First")
                subject.insert("Second")
                subject.insert("Third")
                subject.insert("First")
                subject.insert("Second")
                subject.insert("Third")

                subject.removeSubrange(0..<5)

                expect(subject.items).to(equal([
                    "First"
                    ]))
            }

            it("can migrate an array of strings") {
                subject.migrate([
                    "1",
                    "2",
                    "3",
                    "4"
                    ])

                expect(subject.items).to(equal(["1", "2", "3", "4"]))
            }

            it("can clear the entire history") {
                subject.migrate(["1", "2", "3", "4", "5"])
                subject.saveToDefaults()
                expect(defaults.array(forKey: "historyStore")).to(beAKindOf([[String: String]].self))

                subject.clearHistory()
                expect(subject.items).to(equal([]))

                subject.loadFromDefaults()
                expect(subject.items).to(equal([]))
            }
        }
    }

}
