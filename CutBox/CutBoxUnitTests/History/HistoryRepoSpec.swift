//
//  HistoryRepoSpec.swift
//  CutBoxTests
//
//  Created by Jason on 29/4/18.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

import Quick
import Nimble

class HistoryRepoSpec: QuickSpec {

    override func spec() {
        describe("HistoryRepo") {
            var subject: HistoryRepo!
            var mockedDefaults: UserDefaults!

            beforeEach {
                mockedDefaults = UserDefaultsMock()

                subject = HistoryRepo(defaults: mockedDefaults)
            }

            describe("timeFilter") {
                beforeEach {
                    let oneDayAgo: TimeInterval = -86400.0
                    let oneHourAgo: TimeInterval = -3600.0
                    let oneMinAgo: TimeInterval = -60.0
                    let thirtySecondsAgo: TimeInterval = -10.0

                    subject.insert("Yesterday Item", date: Date(timeIntervalSinceNow: oneDayAgo))
                    subject.insert("Hour Ago Item", date: Date(timeIntervalSinceNow: oneHourAgo))
                    subject.insert("Minute Ago Item", date: Date(timeIntervalSinceNow: oneMinAgo))
                    subject.insert("Thirty Seconds Ago Item", date: Date(timeIntervalSinceNow: thirtySecondsAgo))
                }

                describe("return items filtered by time") {
                    it("will select items within the last N seconds") {
                        subject.timeFilter = 60
                        expect(subject.items.count).to(equal(1))
                    }
                }
            }

            describe("missingTimestampFilter") {
                it("return items that are missing a timestamp") {
                    var mock = (mockedDefaults as! UserDefaultsMock)

                    // fake insert, no timestamp
                    mock.insertHistoryStoreItem("Legacy Item")
                    subject.loadFromDefaults()

                    // insert via CutBox app method
                    subject.insert("Contemporary item")
                    subject.saveToDefaults()

                    expect(subject.items.count).to(equal(2))
                    subject.missingTimestampFilter = true
                    expect(subject.items.count).to(equal(1))
                    expect(subject.missingTimestampDict.count).to(equal(1))
                }
            }

            it("can insert string items and provide them as an array") {
                subject.insert("Hello")
                expect(subject.items).to(contain("Hello"))
            }

            it("provides access to the dictionary store") {
                let date = Date()
                let timestamp = ISO8601DateFormatter().string(from: date)
                subject.insert("Hello", date: date)
                expect(subject.dict.first).to(equal(["string": "Hello", "timestamp": timestamp]))
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

            it("can remove the last item inserted") {
                subject.insert("First")
                subject.insert("Second")
                subject.insert("Third")
                subject.insert("Latest")

                subject.remove(at: 0)

                expect(subject.items.first).to(equal("Third"))
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
                subject.insert("Fourth")
                subject.insert("Fifth")
                subject.insert("Sixth")

                subject.removeSubrange(0..<5)

                expect(subject.items).to(equal([
                    "First"
                    ]))
            }

            it("can migrate an array of strings") {
                subject.migrateLegacyPasteStore(["1", "2", "3", "4"])
                expect(subject.items).to(equal(["1", "2", "3", "4"]))
            }

            it("can clear the entire history") {
                subject.migrateLegacyPasteStore(["1", "2", "3", "4", "5"])
                subject.saveToDefaults()
                expect(mockedDefaults.array(forKey: "historyStore")).to(beAKindOf([[String: String]].self))

                subject.clearHistory()
                expect(subject.items).to(equal([]))

                subject.loadFromDefaults()
                expect(subject.items).to(equal([]))
            }
        }
    }
}
