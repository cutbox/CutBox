//
//  HistoryManagertTest.swift
//  
//  Created by jason on 31/8/23.
//

import Quick
import Nimble

@testable import CutBoxCLICore

class HistoryManagerSpec: QuickSpec {
    override func spec() {
        describe("HistoryManager") {
            var subject: HistoryManager!
            describe("loadHistoryEntries") {
                it("reads history entries from a deserialized plist") {
                    let historyStore = [
                        ["string": "Test Clip 1", "timestamp": "1970-01-01T00:00:01Z"],
                        ["string": "Test Clip 2", "timestamp": "1970-01-01T00:00:02Z", "favorite": "favorite"],
                        ["string": "Test Clip 3", "timestamp": "1970-01-01T00:00:03Z"]
                    ]
                    subject = HistoryManager(plist: ["historyStore": historyStore])

                    expect(subject.loadHistoryEntries()) == [
                        HistoryEntry(string: "Test Clip 1", timestamp: "1970-01-01T00:00:01Z", favorite: nil),
                        HistoryEntry(string: "Test Clip 2", timestamp: "1970-01-01T00:00:02Z", favorite: "favorite"),
                        HistoryEntry(string: "Test Clip 3", timestamp: "1970-01-01T00:00:03Z", favorite: nil)
                    ]
                }

                it("returns an empty array for a dictionary that has no historyStore") {
                    subject = HistoryManager(plist: ["SomeOtherKey": "some other value, not a historyStore"])

                    expect(subject.loadHistoryEntries()) == []
                }
            }
        }
    }
}
