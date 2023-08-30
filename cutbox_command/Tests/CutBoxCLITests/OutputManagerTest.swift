//
//  OutputManagerTest.swift
//
//  Created by jason on 31/8/23.
//

import Quick
import Nimble

@testable import CutBoxCLICore

class OutputManagerSpec: QuickSpec {
    override func spec() {
        describe("OutputManager") {
            var mockOutput: MockOutput!
            var historyEntries: [HistoryEntry]!
            var subject: OutputManager!

            beforeEach {
                mockOutput = MockOutput()
                historyEntries = [HistoryEntry]()

                historyEntries.append(HistoryEntry(string: "Test 1", timestamp: "1970-01-01T00:00:00Z", favorite: nil))
                historyEntries.append(HistoryEntry(string: "Test 2", timestamp: "1970-01-02T00:00:00Z", favorite: nil))
                historyEntries.append(HistoryEntry(string: "Test 3", timestamp: "1970-01-03T00:00:00Z", favorite: nil))

                subject = OutputManager()
            }

            it("outputs history entries") {
                let params = CommandParams(out: mockOutput, arguments: [])
                subject.printEntries(historyEntries, params: params, out: mockOutput)

                expect(mockOutput.printLog) == "Test 1\nTest 2\nTest 3\n"
            }

            it("outputs history entries with timestamps") {
                let params = CommandParams(out: mockOutput, arguments: ["--show-time"])
                subject.printEntries(historyEntries, params: params, out: mockOutput)

                expect(mockOutput.printLog) ==
                "1970-01-01T00:00:00Z: Test 1\n" +
                "1970-01-02T00:00:00Z: Test 2\n" +
                "1970-01-03T00:00:00Z: Test 3\n"
            }

            it("outputs history entries with UNKNOWN for missing timestamps") {
                let params = CommandParams(out: mockOutput, arguments: ["--show-time"])
                historyEntries.append(HistoryEntry(string: "Test 4",
                                                   timestamp: nil,
                                                   favorite: nil))

                subject.printEntries(historyEntries, params: params, out: mockOutput)

                expect(mockOutput.printLog) ==
                "1970-01-01T00:00:00Z: Test 1\n" +
                "1970-01-02T00:00:00Z: Test 2\n" +
                "1970-01-03T00:00:00Z: Test 3\n" +
                "UNKNOWN DATETIME: Test 4\n"
            }
        }
    }
}
