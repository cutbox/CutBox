//
//  HistoryEntryTest.swift
//
//  Created by jason on 31/8/23.
//

import Quick
import Nimble

@testable import CutBoxCLICore

class HistoryEntrySpec: QuickSpec {
    override func spec() {
        describe("HistoryEntry") {
            it("describes a cutbox history entry") {
                let subject = HistoryEntry(string: "CutBox item",
                                           timestamp: "1970-01-01T00:00:00Z",
                                           favorite: nil)
                expect(subject.string) == "CutBox item"
                expect(subject.favorite).to(beNil())
            }

            it("describes a favorite cutbox history entry") {
                let subject = HistoryEntry(string: "CutBox item",
                                           timestamp: "1970-01-01T00:00:00Z",
                                           favorite: "favorite")
                expect(subject.favorite).notTo(beEmpty())
            }

            describe("timeIntervalSince1970") {
                it("returns the timestamp as unix epoch seconds") {
                    expect(HistoryEntry(string: "test",
                                        timestamp: "1970-01-01T00:00:00Z",
                                        favorite: nil)
                        .timeIntervalSince1970) == 0
                }

                it("returns nil if no timestamp is set") {
                    expect(HistoryEntry(string: "test",
                                        timestamp: nil,
                                        favorite: nil)
                        .timeIntervalSince1970).to(beNil())
                }
            }
        }
    }
}
