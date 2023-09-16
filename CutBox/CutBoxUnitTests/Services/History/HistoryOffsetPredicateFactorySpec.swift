//
//  HistoryOffsetPredicateFactorySpec.swift
//  CutBox
//
//  Created by Jason Milkins on 15/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class HistoryOffsetPredicateFactorySpec: QuickSpec {
    override func spec() {

        describe("historyOffsetPredicateFactory ISO8601 Strings)") {
            var timestamps: [String]!

            beforeEach {
                timestamps = [0, -900, -1800, -7200, -86400]
                    .map { iso8601Timestamp(fromDate: Date().addingTimeInterval($0)) }
            }

            context("with positive offset") {
                it("should filter dates newer than cutoff") {
                    let offset: TimeInterval = 3601 // 1 hour
                    let filterPredicate: (String) -> Bool = historyOffsetPredicateFactory(offset: offset)
                    let filteredDates = timestamps.filter(filterPredicate)

                    expect(filteredDates).to(equal(Array(timestamps[...2])))
                }
            }

            context("with negative offset") {
                it("should filter dates older than calculated cutoff") {
                    let offset: TimeInterval = -1801 // -30 minutes
                    let filterPredicate: (String) -> Bool = historyOffsetPredicateFactory(offset: offset)
                    let filteredDates = timestamps.filter(filterPredicate)

                    expect(filteredDates).to(equal(Array(timestamps[3...])))
                }
            }
        }

        describe("historyOffsetPredicateFactory Dates") {
            var dates: [Date]!

            beforeEach {
                dates = [0, -900, -1800, -7200, -86400]
                    .map { Date().addingTimeInterval($0) }
            }

            context("with positive offset") {
                it("should filter dates newer than cutoff") {
                    let offset: TimeInterval = 3601 // 1 hour
                    let filterPredicate: (Date) -> Bool = historyOffsetPredicateFactory(offset: offset)
                    let filteredDates = dates.filter(filterPredicate)

                    expect(filteredDates).to(equal(Array(dates[...2])))
                }
            }

            context("with negative offset") {
                it("should filter dates older than calculated cutoff") {
                    let offset: TimeInterval = -1801 // -30 minutes
                    let filterPredicate: (Date) -> Bool = historyOffsetPredicateFactory(offset: offset)
                    let filteredDates = dates.filter(filterPredicate)

                    expect(filteredDates).to(equal(Array(dates[3...])))
                }
            }
        }
    }
}
