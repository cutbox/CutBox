//
//  CutBoxCLISpec.swift
//  cutboxCLITests
//
//  Created by jason on 25/8/23.
//
import Foundation
import Quick
import Nimble

@testable import CutBoxCLICore

class MockOutput: POutput {
    var logged = ""

    func log(_ string: String) {
        logged += string + "\n"
    }
}

class CutBoxCLISpec: QuickSpec {
    override func spec() {
        let iso = DateFormatter()
        iso.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        var historyEntries: [[String: Any]]!
        var out: MockOutput!
        var plist: [String: Any] = [:]

        func cutbox(_ arguments: String ...) -> String {
            CommandLine.arguments = arguments
            cutBoxCliMain(out: out, plist: plist)
            return out.logged
        }

        func timestampNow() -> String {
            iso.string(from: Date())
        }

        func timestampSecondsAgo(_ secs: Double) -> String {
            iso.string(from: Date(timeIntervalSinceNow: -secs))
        }

        let firstTimestamp = timestampSecondsAgo(3600 * 24 * 2)
        let lastTimestamp = timestampSecondsAgo(360)

        describe("CutBoxCLI loadPlist") {
            it("Loads a plist") {
                let bundle = Bundle.module
                let plistFilename = "info.ocodo.CutBox.plist"

                if let path = bundle.path(forResource: "info.ocodo.CutBox", ofType: "plist") {
                    plist = loadPlist(path: path)
                    out = MockOutput()
                    let output = cutbox("--show-date")
                    expect(output) == "2023-08-25T15:12:36Z: Test three\n\n2023-08-25T15:12:30Z: Test two\n\n2023-08-25T15:12:23Z: Test one\n\n"
                } else {
                    fail("couldn't load \(plistFilename)")
                }
            }
        }

        describe("CutBox CLI") {
            beforeEach {
                historyEntries = [[:]]
                // favorite
                historyEntries.append([
                    "string": "Test Passed?",
                    // a couple of days ago
                    "timestamp": firstTimestamp,
                    "favorite": "favorite"])
                // No timestamp
                historyEntries.append([
                    "string": "Copied Text"])
                // regular entry
                historyEntries.append([
                    "string": "Copied text",
                    // 6 minutes ago
                    "timestamp": lastTimestamp])
                plist["historyStore"] = historyEntries
                
                out = MockOutput()
            }

            it("cutbox") {
                let expectedOutput = "Test Passed?\nCopied Text\nCopied text\n"
                expect(cutbox()).to(equal(expectedOutput))
            }

            it("cutbox --show-time") {
                let expectedOutput =
                "\(firstTimestamp): Test Passed?\n" +
                "UNKNOWN DATETIME: Copied Text\n" +
                "\(lastTimestamp): Copied text\n"
                expect(cutbox("--show-time")).to(equal(expectedOutput))
            }

            it("cutbox --limit 2") {
                let expectedOutput = "Test Passed?\nCopied Text\n"
                expect(cutbox("--limit", "2")).to(equal(expectedOutput))
            }

            it("cutbox -l 1") {
                let expectedOutput = "Test Passed?\n"
                expect(cutbox("-l", "1")).to(equal(expectedOutput))
            }
            
            it("cutbox --help") {
                expect(cutbox("--help")) == usageInfo() + "\n"
            }

            it("cutbox --fuzzy text") {
                expect(cutbox("--fuzzy", "text")) == "Copied Text\nCopied text\n"
            }

            it("cutbox --fuzzy zoo") {
                expect(cutbox("--fuzzy", "zoo")) == "\n"
            }

            it("cutbox --regex Text") {
                expect(cutbox("--regex", "Text")) == "Copied Text\n"
            }

            it("cutbox --regexi Text") {
                expect(cutbox("--regexi", "Text")) == "Copied Text\nCopied text\n"
            }

            it("cutbox --favorites") {
                expect(cutbox("--favorites")) == "Test Passed?\n"
            }

            it("cutbox --missing-date") {
                expect(cutbox("--missing-date")) == "Copied Text\n"
            }

            it("cutbox --since 7mins") {
                expect(cutbox("--since", "7mins")) == "Copied text\n"
            }

            it("cutbox --since 2.1day") {
                expect(cutbox("--since", "2.1day")) == "Test Passed?\nCopied text\n"
            }

            it("cutbox --before 2.1day") {
                expect(cutbox("--before", "2.1day")) == "\n"
            }

            it("cutbox --before 2.1sec") {
                let expectedOutput = "Test Passed?\nCopied text\n"
                expect(cutbox("--before", "2.1sec")) == expectedOutput
            }

            it("cutbox --before 5hrs --since 2.1days") {
                expect(cutbox("--before", "5hrs", "--since", "2.1days")) == "Test Passed?\n"
            }

            it("cutbox --before hour") {
                expect(cutbox("--before", "hour")) == "Test Passed?\nCopied Text\nCopied text\n"
            }

            it("cutbox --since-date 2023-06-05T09:21:59Z") {
                expect(cutbox("--since-date", "2023-06-05T09:21:59Z")) == "Test Passed?\nCopied text\n"
            }

            it("cutbox -l 1.012") {
                let expectedOutput = "Test Passed?\nCopied Text\nCopied text\n"
                expect(cutbox("-l", "1.012")).to(equal(expectedOutput))
            }

            it("cutbox -l -v missing limit value.") {
                let expectedOutput = "Test Passed?\nCopied Text\nCopied text\n"
                expect(cutbox("-l", "-v")).to(equal(expectedOutput))
            }

            it("cutbox --regex invalid") {
                let expectedOutput = "\n"
                expect(cutbox("--regex", "[^{]*....\\/\\\\ }")) == expectedOutput
            }

            it("cutbox --before-date invalid timestamp") {
                let expectedOutput = "Test Passed?\nCopied Text\nCopied text\n"
                expect(cutbox("--before-date", "[^{]*....\\/\\\\ }")) == expectedOutput
            }

            it("cutbox --before-date missing timestamp") {
                let expectedOutput = "Test Passed?\nCopied Text\nCopied text\n"
                expect(cutbox("--before-date", "-v")) == expectedOutput
            }

            it("cutbox --since-date invalid timestamp") {
                let expectedOutput = "Test Passed?\nCopied Text\nCopied text\n"
                expect(cutbox("--since-date", "[^{]*....\\/\\\\ }")) == expectedOutput
            }

            it("cutbox --since-date missing timestamp") {
                let expectedOutput = "Test Passed?\nCopied Text\nCopied text\n"
                expect(cutbox("--since-date", "-v")) == expectedOutput
            }
        }
    }
}
