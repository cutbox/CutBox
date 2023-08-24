//
//  HistoryStoreMigration_1_6_x_Spec.swift
//  CutBoxUnitTests
//
//  Created by jason on 21/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class HistoryStoreMigration_1_6_x_Spec: QuickSpec {
    override func spec() {
        let mockDefaults = UserDefaultsMock()

        describe("HistoryStoreMigration_1_6_x") {
            context("Check history store via defaults") {
                context("clean app startup") {
                    it("checks for existing history store") {
                        let subject = HistoryStoreMigration_1_6_x(defaults: mockDefaults)
                        let result = subject.isMigrationRequired
                        expect(result).to(equal(false))
                    }
                }

                context("legacy history startup") {
                    var subject: HistoryStoreMigration_1_6_x!

                    beforeEach {
                        subject = HistoryStoreMigration_1_6_x(defaults: mockDefaults)
                        mockDefaults.store["historyStore"] = [
                            ["string": "apple", "timestamp": "2021-04-05T08:15:30Z"],
                            ["string": "banana", "timestamp": "2023-02-10T21:45:00Z"],
                            ["string": "orange"],
                            ["string": "grape", "timestamp": "2022-06-30T12:10:20Z"],
                            ["string": "kiwi"],
                            ["string": "pear"],
                            ["string": "melon"],
                            ["string": "peach"]                         ]
                    }

                    it("checks for existing historyStore and then for legacy items") {
                        let result = subject.isMigrationRequired
                        expect(result).to(beTrue())
                    }

                    context("applyTimestampsToLegacyItems") {
                        var historyStore: [[String: String]]!

                        beforeEach {
                            // swiftlint:disable force_cast
                            historyStore = (mockDefaults.store["historyStore"] as? [[String: String]])!
                            subject.applyTimestampsToLegacyItems()
                        }

                        it("migrates legacy items") {
                            expect(subject.isMigrationRequired).to(beFalse())
                        }

                        it("applies migration without disrupting store order") {
                            let strings = historyStore.map { $0["string"] }
                            let expected = [
                                "apple", "banana", "orange", "grape", "kiwi", "pear", "melon", "peach"
                            ]
                            expect(strings).to(equal(expected))
                        }

                        it("applies migration timestamps one second apart.") {
                            let historyStore = mockDefaults.store["historyStore"] as! [[String: String]]
                            let updatedItems = ["orange", "kiwi", "pear", "melon", "peach"]

                            // Get the new timestamps from the updated items
                            let updatedTimestamps = historyStore
                                .filter { updatedItems.contains($0["string"]!) }
                                .map { $0["timestamp"]! }

                            // Check they're one second apart
                            expect(self.timestampsOneSecondApart(updatedTimestamps)).to(beTrue())
                        }
                    }
                }
            }
        }
    }

    func timestampsOneSecondApart(_ timestamps: [String]) -> Bool {
        guard timestamps.count > 1 else {
            // 0 or 1 items is a passing array by default
            return true
        }
        let dateFormatter = ISO8601DateFormatter()
        for index in 1..<timestamps.count {
            if let date1 = dateFormatter.date(from: timestamps[index - 1]),
               let date2 = dateFormatter.date(from: timestamps[index]) {
                let timeDifference = date2.timeIntervalSince(date1)
                if timeDifference != 1.0 {
                    // The date1 and date2 are not 1 sec apart.
                    return false
                }
            } else {
                // Invalid date format
                return false
            }
        }

        // Checks passed
        return true
    }
}
