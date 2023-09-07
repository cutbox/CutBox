//
//  HistoryStoreMigration_1_6_x_Spec.swift
//  CutBoxUnitTests
//
//  Created by Jason Milkins on 21/8/23.
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
                            ["string": "grape", "timestamp": "2022-06-30T12:10:20Z"],
                            ["string": "orange"],
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
                                "apple", "banana", "grape", "orange", "kiwi", "pear", "melon", "peach"
                            ]
                            expect(strings).to(equal(expected))
                        }

                        context("tolerance of up to ±1 second") {
                            it("applies migration timestamps spaced approximately one second apart ±1") {
                                let historyStore = mockDefaults.store["historyStore"] as! [[String: String]]
                                let updatedItems = ["orange", "kiwi", "pear", "melon", "peach"]

                                let updatedTimestamps = historyStore
                                    .filter { updatedItems.contains($0["string"]!) }
                                    .map { $0["timestamp"]! }

                                expect(self.timestampsOneSecondApart(updatedTimestamps, tolerance: 0.2)).to(beTrue())
                            }
                        }
                    }
                }
            }
        }

        describe("timestampsOneSecondApart") {
            context("for an array with zero or one timestamp") {
                it("should return true for an empty array") {
                    let timestamps: [String] = []
                    expect(self.timestampsOneSecondApart(timestamps)).to(beTrue())
                }

                it("should return true for an array with one timestamp") {
                    let timestamps = ["2023-08-30T12:00:00Z"]
                    expect(self.timestampsOneSecondApart(timestamps)).to(beTrue())
                }

                it("should return true for an array with one of anything") {
                    let timestamps = ["No Comparison ¯\\_(ツ)_/¯"]
                    expect(self.timestampsOneSecondApart(timestamps)).to(beTrue())
                }
            }
            context("for an array with two or more timestamps") {
                it("should return true for passing timestamps") {
                    let timestamps = [
                        "2023-08-30T12:00:00Z",
                        "2023-08-30T12:00:01Z"
                    ]
                    expect(self.timestampsOneSecondApart(timestamps)).to(beTrue())
                }

                it("should return false for failing timestamps") {
                    let timestamps = [
                        "2023-08-30T12:00:00Z",
                        "2023-08-30T12:00:02Z"
                    ]
                    expect(self.timestampsOneSecondApart(timestamps)).to(beFalse())
                }

                it("should return false if any timestamps are invalid") {
                    let timestamps = [
                        "2023-08-30T12:00:00Z",
                        "2023 THIS IS NOT A TIMESTAMP",
                        "2023-08-30T12:00:02Z"
                    ]
                    expect(self.timestampsOneSecondApart(timestamps)).to(beFalse())
                }
                context("with tolerance of ±1.0") {
                    it("should return true for timestamps 2 sec apart or less") {
                        let timestamps = [
                            "2023-08-30T12:00:00Z",
                            "2023-08-30T12:00:02Z"
                        ]
                        expect(self.timestampsOneSecondApart(timestamps, tolerance: 1.0)).to(beTrue())
                    }
                }
            }
        }
    }

    func timestampsOneSecondApart(_ timestamps: [String], tolerance: TimeInterval = 0.0) -> Bool {
        guard timestamps.count > 1 else {
            return true
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        for index in 1..<timestamps.count {
            if let date1 = dateFormatter.date(from: timestamps[index - 1]),
               let date2 = dateFormatter.date(from: timestamps[index]) {
                let timeDifference = date2.timeIntervalSince(date1)
                if abs(timeDifference - 1.0) > tolerance {
                    print("Time difference failed: \(timeDifference)")
                    return false
                }
            } else {
                return false
            }
        }
        return true
    }

}
