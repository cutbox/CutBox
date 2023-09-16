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
            var mockedDefaults: UserDefaultsMock!
            var preferences: CutBoxPreferencesService!

            // Time offsets
            let oneDayAgoOffset: TimeInterval = -86400.0
            let oneHourAgoOffset: TimeInterval = -3600.0
            let oneMinAgoOffset: TimeInterval = -60.0
            let thirtySecondsAgoOffset: TimeInterval = -30.0

            // Test Dates
            let aDayAgoDate = Date(timeIntervalSinceNow: -86400.0)
            let anHourAgoDate = Date(timeIntervalSinceNow: -3600.0)
            let threeDaysAgoDate = Date(timeIntervalSinceNow: -86400.0 * 3)
            let lastWeekDate = Date(timeIntervalSinceNow: -86400.0 * 8)

            beforeEach {
                mockedDefaults = UserDefaultsMock()
                preferences = CutBoxPreferencesService(defaults: mockedDefaults)
                subject = HistoryRepo(
                    defaults: mockedDefaults,
                    prefs: preferences)
            }

            describe("timeFilter") {
                beforeEach {
                    subject.insert("Yesterday Item",
                                   date: Date(timeIntervalSinceNow: oneDayAgoOffset))
                    subject.insert("Hour Ago Item",
                                   date: Date(timeIntervalSinceNow: oneHourAgoOffset))
                    subject.insert("Minute Ago Item",
                                   date: Date(timeIntervalSinceNow: oneMinAgoOffset))
                    subject.insert("Thirty Seconds Ago Item",
                                   date: Date(timeIntervalSinceNow: thirtySecondsAgoOffset))
                }

                describe("return items filtered by time") {
                    it("will select items within the last N seconds") {
                        subject.timeFilter = 60
                        expect(subject.items.count).to(equal(1))
                    }
                }
            }

            it("can insert string items and provide them as an array") {
                subject.insert("Hello")
                expect(subject.items).to(contain("Hello"))
            }

            it("provides access to the dictionary store") {
                let date = Date()
                let timestamp = iso8601Timestamp(fromDate: date)
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

            context("favorites") {
                context("insert") {
                    it("can insert an item as a favorite") {
                        let zero = Date(timeIntervalSince1970: 0)
                        subject.insert("First")
                        subject.insert("Second")
                        subject.insert("Third", isFavorite: true, date: zero)
                        expect(subject.favoritesDict) == [
                            [
                                "string": "Third",
                                "favorite": "favorite",
                                "timestamp": "1970-01-01T00:00:00Z"
                            ]
                        ]
                    }
                }

                context("toggleFavorite at index") {
                    it("should set favorite on an item by index") {
                        subject.insert("First")
                        subject.insert("Second")
                        subject.insert("Third")
                        subject.toggleFavorite(at: 1)
                        expect(subject.favorites) == ["Second"]
                        subject.toggleFavorite(at: 1)
                        expect(subject.favorites) == []
                    }
                }

                context("toggleFavorite indexes") {
                    it("should set favorite on items by IndexSet") {
                        subject.insert("Apple")
                        subject.insert("Peach")
                        subject.insert("Grapefruit")
                        subject.insert("Watermelon")
                        subject.insert("Nice cup of coffee")

                        subject.toggleFavorite(indexes: IndexSet(2...4))
                        expect(subject.favorites) == ["Grapefruit", "Peach", "Apple"]
                        subject.toggleFavorite(indexes: IndexSet(0...4))
                        expect(subject.favorites) == ["Nice cup of coffee", "Watermelon"]
                        subject.toggleFavorite(indexes: IndexSet(0...1))
                        expect(subject.favorites) == []
                    }
                }
            }

            it("can remove items while protecting favorites") {
                preferences.protectFavorites = true

                subject.migrateLegacyPasteStore([
                    "Peach",
                    "Orange",
                    "Apple",
                    "Mango"
                ])

                subject.toggleFavorite(at: 3)
                subject.clearHistory()

                expect(subject.items.first) == "Mango"
                expect(subject.items.count) == 1
            }

            it("can migrate an array of strings") {
                subject.migrateLegacyPasteStore(["1", "2", "3", "4"])
                expect(subject.items).to(equal(["1", "2", "3", "4"]))
            }

            context("timeFilterPredicate") {
                it("returns false for items with older timestamps") {
                    let fakeItem = [
                        "string": "Yesterday",
                        "timestamp": iso8601Timestamp(fromDate: lastWeekDate)
                    ]
                    let result = subject.timeFilterPredicate(
                        item: fakeItem,
                        earliest: iso8601Timestamp(fromDate: threeDaysAgoDate))

                    expect(result) == false
                }

                it("returns true for items with newer timestamps") {
                    let fakeItem = [
                        "string": "Yesterday",
                        "timestamp": iso8601Timestamp(fromDate: aDayAgoDate)
                    ]
                    let result = subject.timeFilterPredicate(
                        item: fakeItem,
                        earliest: iso8601Timestamp(fromDate: threeDaysAgoDate))

                    expect(result) == true
                }
            }

            context("clear history") {
                it("removes history") {
                    subject.migrateLegacyPasteStore(["1", "2", "3", "4", "5"])
                    subject.saveToDefaults()
                    expect(mockedDefaults.array(forKey: "historyStore")).to(beAKindOf([[String: String]].self))

                    subject.clearHistory()

                    subject.loadFromDefaults()
                    expect(subject.items).to(equal([]))
                }

                context("time filtered") {
                    context("legacy items without a timestamp") {
                        beforeEach {
                            subject.insert("Eggs and Bakey", date: nil)
                            subject.insert("Wakey Wakey", date: nil)
                            subject.insert("Good morning")
                        }

                        it("should ignore legacy items without a timestamp") {
                            // Although they should not exist after startup historyStore migration
                            subject.clearHistory(
                                timestampPredicate: historyOffsetPredicateFactory(offset: -10.0))

                            expect(subject.items.count) == 3
                        }
                    }

                    context("items since 1.5.5") {
                        beforeEach {
                            subject.insert("Apple", date: anHourAgoDate)

                            subject.insert("Peach", date: threeDaysAgoDate)

                            subject.insert("Peach", isFavorite: true, date: lastWeekDate)
                        }

                        context("when favorites are protected") {
                            it("should clear non-favorite history using a time limit") {
                                preferences.protectFavorites = true

                                expect(subject.dict.count) == 3

                                // filter before today
                                subject.clearHistory(
                                    timestampPredicate:
                                        historyOffsetPredicateFactory(offset: -86400.0)
                                )

                                expect(subject.dict.count) == 2
                            }
                        }

                        context("when favorites are not protected") {
                            it("should clear any items history using a time limit") {
                                preferences.protectFavorites = false

                                expect(subject.dict.count) == 3

                                // filter before today
                                subject.clearHistory(
                                    timestampPredicate:
                                        historyOffsetPredicateFactory(offset: -86400.0)
                                )

                                expect(subject.dict.count) == 1
                            }
                        }
                    }
                }
            }
        }
    }
}
