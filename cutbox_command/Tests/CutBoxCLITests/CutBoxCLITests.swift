//
//  CutBoxCLISpec.swift
//  cutboxCLITests
//
//  Created by Jason Milkins on 25/8/23.
//
import Foundation
import Quick
import Nimble

@testable import CutBoxCLICore

class MockOutput: Output {
    var printLog = ""
    var errorLog = ""

    override func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        printLog += items
            .map { String(describing: $0) }
            .joined(separator: separator) + terminator
    }

    override func error(_ items: Any..., separator: String = " ", terminator: String = "\n") {
        errorLog += items
            .map { String(describing: $0) }
            .compactMap{ $0 }
            .joined(separator: separator) + terminator
    }
}

class CutBoxCLISpec: QuickSpec {
    override func spec() {
        let iso = DateFormatter()
        iso.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        var historyEntries: [[String: Any]]!
        var out: MockOutput!
        var plist: [String: Any] = [:]

        let emptyOutput = ""
        let emptyPrintedOutput = "\n"

        func cutbox(_ arguments: String ...) {
            CommandLine.arguments = arguments
            cutBoxCliMain(out: out, plist: plist)
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

                    let expected =
                      "2023-08-25T15:12:36Z: Test three\n\n" +
                      "2023-08-25T15:12:30Z: Test two\n\n" +
                      "2023-08-25T15:12:23Z: Test one\n\n"

                    cutbox("--show-date")

                    expect(out.printLog) == expected

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
            
            context("valid arguments") {
                it("cutbox") {
                    let expectedOutput = "Test Passed?\nCopied Text\nCopied text\n"

                    cutbox()
                    expect(out.printLog) == expectedOutput
                }

                it("cutbox --show-time") {
                    let expectedOutput =
                    "\(firstTimestamp): Test Passed?\n" +
                    "UNKNOWN DATETIME: Copied Text\n" +
                    "\(lastTimestamp): Copied text\n"

                    cutbox("--show-time")
                    expect(out.printLog) == expectedOutput
                }

                it("cutbox --limit 2") {
                    let expectedOutput = "Test Passed?\nCopied Text\n"

                    cutbox("--limit", "2")
                    expect(out.printLog) == expectedOutput
                }

                it("cutbox -l 1") {
                    cutbox("-l", "1")
                    expect(out.printLog) == "Test Passed?\n"
                }

                it("cutbox --help") {
                    cutbox("--help")
                    expect(out.printLog) == usageInfo() + "\n"
                }

                it("cutbox --fuzzy text") {
                    cutbox("--fuzzy", "text")
                    expect(out.printLog) == "Copied Text\nCopied text\n"
                }

                it("cutbox --fuzzy zoo") {
                    cutbox("--fuzzy", "zoo")
                    expect(out.printLog) == emptyPrintedOutput
                }

                it("cutbox --string-match 'ied tex'") {
                    cutbox("--string-match", "ied tex")
                    expect(out.printLog) == "Copied text\n"
                }

                it("cutbox -s 'text'") {
                    cutbox("-s", "text")
                    expect(out.printLog) == "Copied text\n"
                }

                it("cutbox --regex Text") {
                    cutbox("--regex", "Text")
                    expect(out.printLog) == "Copied Text\n"
                }

                it("cutbox --regexi Text") {
                    cutbox("--regexi", "Text")
                    expect(out.printLog) == "Copied Text\nCopied text\n"
                }

                it("cutbox --favorites") {
                    cutbox("--favorites")
                    expect(out.printLog) == "Test Passed?\n"
                }

                it("cutbox --missing-date") {
                    cutbox("--missing-date")
                    expect(out.printLog) == "Copied Text\n"
                }

                it("cutbox --since 7mins") {
                    cutbox("--since", "7mins")
                    expect(out.printLog) == "Copied text\n"
                }

                it("cutbox --since 2.1day") {
                    cutbox("--since", "2.1day")
                    expect(out.printLog) == "Test Passed?\nCopied text\n"
                }

                it("cutbox --before 2.1day") {
                    cutbox("--before", "2.1day")
                    expect(out.printLog) == emptyPrintedOutput
                }

                it("cutbox --before 2.1sec") {
                    let expectedOutput = "Test Passed?\nCopied text\n"
                    cutbox("--before", "2.1sec")
                    expect(out.printLog) == expectedOutput
                }

                it("cutbox --before 5hrs --since 2.1days") {
                    cutbox("--before", "5hrs", "--since", "2.1days")
                    expect(out.printLog) == "Test Passed?\n"
                }

                it("cutbox --before hour") {
                    cutbox("--before", "hour")
                    expect(out.printLog) == emptyOutput
                }

                it("cutbox --since-date 2023-06-05T09:21:59Z") {
                    cutbox("--since-date", "2023-06-05T09:21:59Z")
                    expect(out.printLog) == "Test Passed?\nCopied text\n"
                }

                it("cutbox -l 1.012") {
                    let expectedOutput = "Test Passed?\nCopied Text\nCopied text\n"
                    cutbox("-l", "1.012")
                    expect(out.printLog) == expectedOutput
                }

                it("cutbox -l -v missing limit value.") {
                    let expectedError = "Invalid argument: -l \nInvalid argument: -v \n"

                    cutbox("-l", "-v")
                    expect(out.printLog) == emptyOutput
                    expect(out.errorLog) == expectedError
                }

                it("cutbox --regex ") {
                    let expectedOutput = emptyPrintedOutput
                    cutbox("--regex", ".*///\\\\....\\/\\\\ }")
                    expect(out.printLog) == expectedOutput
                    expect(out.errorLog) == emptyOutput
                }

                it("cutbox --before-date invalid timestamp") {
                    let expectedError = "Invalid argument: --before-date lkgjfglsdkjgsldfkjg\n"
                    cutbox("--before-date", "lkgjfglsdkjgsldfkjg")
                    expect(out.errorLog) == expectedError
                    expect(out.printLog) == ""
                }

                it("cutbox --before-date missing timestamp") {
                    cutbox("--before-date", "-v")
                    expect(out.printLog) == emptyOutput
                    expect(out.errorLog) == "Invalid argument: --before-date \nInvalid argument: -v \n"
                }

                it("cutbox --since-date invalid timestamp") {
                    let expectedOutput = "Invalid argument: --since-date [^{]*....\\/\\\\ }\n"
                    cutbox("--since-date", "[^{]*....\\/\\\\ }")
                    expect(out.errorLog) == expectedOutput
                    expect(out.printLog) == emptyOutput
                }

                it("cutbox --since-date missing timestamp") {
                    let expectedError = "Invalid argument: --since-date \nInvalid argument: -v \n"
                    cutbox("--since-date", "-v")
                    expect(out.errorLog) == expectedError
                    expect(out.printLog) == emptyOutput
                }
            }

            context("invalid arguments") {
                it("cutbox --power-level Over9000") {
                    let expectedErrorLog = "Invalid argument: --power-level Over9000\n"
                    cutbox("--power-level", "Over9000")
                    expect(out.errorLog) == expectedErrorLog
                    expect(out.printLog) == emptyOutput
                }
            }
        }
    }
}
