//
//  HistoryServiceSpec.swift
//  CutBoxTests
//
//  Created by Jason on 12/4/18.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import RxSwift

private class HistoryRepoMock: HistoryRepo {}

private class PasteboardWrapperMock: PasteboardWrapperType {
    var pasteboardItems: [NSPasteboardItem]?

    func addToFakePasteboard(string: String) {
        let item = NSPasteboardItem(pasteboardPropertyList: string, ofType: .string)!
        pasteboardItems?.insert(item, at: 0)
    }

    init() {
        pasteboardItems = []
    }
}

private func addToFakePasteboardAndPoll(string: String,
                                        subject: HistoryService,
                                        pboard: PasteboardWrapperMock) {
    pboard.addToFakePasteboard(string: string)
    subject.pollPasteboard()
}

class HistoryServiceSpec: QuickSpec {
    override func spec() {
        var subject: HistoryService!
        var mockPasteboard: PasteboardWrapperMock!
        var mockHistoryRepo: HistoryRepoMock!
        var defaults: UserDefaults!

        let fakeItems = [
            "Foo bar",
            "Fizz Buzz",
            "Bob the Hoojah Melon",
            "JR Bob Dobbs",
            "[looks like a regex] .* use a substring match?",
            "Most importantly doesn't fuzzy match with anything else, I'm sure.",
            "Generic code sample",
            "Boustrophedon",
            "Bobby",
            "Robobt",
            "Unexpected analogy",
            "Boost boost",
            "39124741",
            "FF443211",
            "Bob",
            "#ff11ab",
            "#FF0022",
            "Example"
        ]

        beforeEach {
            defaults = UserDefaultsMock()
            subject = HistoryService(defaults: defaults)

            mockPasteboard = PasteboardWrapperMock()
            mockHistoryRepo = HistoryRepoMock()

            subject.pasteboard = mockPasteboard
            subject.historyRepo = mockHistoryRepo

            subject.clear()
        }

        it("starts with an empty pasteboard") {
            expect(subject.count) == 0
        }

        context("Pasteboard items history") {
            beforeEach {
                fakeItems.forEach {
                    addToFakePasteboardAndPoll(string: $0,
                                               subject: subject,
                                               pboard: mockPasteboard)
                }
                subject.filterText = nil
            }

            it("read the latest item from the attached pasteboard") {
                let clipboardContent = subject.clipboardContent()!
                expect(clipboardContent) == "Example"
            }

            it("stores clipboard content") {
                expect(subject.count) == 18
                expect(subject.items.first) == "Example"
            }

            it("can clear its storage") {
                expect(subject.count) == 18
                subject.clear()
                expect(subject.count) == 0
            }

            context("password manager support") {
                it("Removes the most recent item when an empty string is the current pasteboard item") {
                    addToFakePasteboardAndPoll(string: "",
                                               subject: subject,
                                               pboard: mockPasteboard)
                    expect(subject.items.count) == 17
                    expect(subject.items.first) == "#FF0022"
                }
            }

            context("duplicate handling") {
                it("removes duplicate items and inserts them as first history item") {
                    expect(subject.items.count) == 18

                    addToFakePasteboardAndPoll(string: "JR Bob Dobbs",
                                               subject: subject,
                                               pboard: mockPasteboard)

                    expect(subject.items.count) == 18
                    expect(subject.items.first) == "JR Bob Dobbs"
                }
            }

            context("history limit set") {
                it("truncates the history to the history limit") {
                    subject.historyLimit = 10
                    expect(subject.items.count) == 10

                    subject.historyLimit = 13
                    expect(subject.items.count) == 10
                }

                it("adds items and removes oldest item") {
                    subject.historyLimit = 10
                    expect(subject.items.count) == 10

                    addToFakePasteboardAndPoll(string: "New New News",
                                               subject: subject,
                                               pboard: mockPasteboard)

                    expect(subject.items.count) == 10
                }
            }

            context("searching") {
                context("fuzzy match") {
                    beforeEach {
                        subject.searchMode = .fuzzyMatch
                    }

                    it("sorts/filters items based on how closely they match") {
                        // The length and appearance of search string
                        // deltas ordering factors

                        subject.filterText = "2"
                        expect(subject.items) == [
                            "#FF0022",
                            "FF443211",
                            "39124741"
                        ]

                        subject.filterText = "Most importantly"
                        expect(subject.items) == [
                            "Most importantly doesn't fuzzy match with anything else, I'm sure."
                        ]

                        subject.filterText = "Bob"
                        expect(subject.items) == [
                            "Bob",
                            "Bobby",
                            "Boost boost",
                            "Bob the Hoojah Melon",
                            "JR Bob Dobbs",
                            "Robobt"
                        ]
                    }
                }

                context("substring") {
                    beforeEach {
                        subject.searchMode = .substringMatch
                    }

                    it("does a literal string match") {
                        subject.filterText = "[looks like a regex] .*"
                        expect(subject.items) == [
                            "[looks like a regex] .* use a substring match?"
                        ]
                    }
                }
            }

            context("regexp") {
                context("case insensitive") {
                    beforeEach {
                        subject.searchMode = .regexpAnyCase
                    }

                    it("filters regexp matches") {
                        subject.filterText = "Bob"
                        expect(subject.items) == [
                            "Bob",
                            "Robobt",
                            "Bobby",
                            "JR Bob Dobbs",
                            "Bob the Hoojah Melon"
                        ]

                        subject.filterText = "^#[a-f0-9]+$"
                        expect(subject.items) == [
                            "#FF0022",
                            "#ff11ab"
                        ]
                    }
                }
                context("case sensitive") {
                    beforeEach {
                        subject.searchMode = .regexpStrictCase
                    }

                    it("filters case sensitive regexp matches") {
                        subject.filterText = "Bob"
                        expect(subject.count) == 4
                        expect(subject.items.last) == "Bob the Hoojah Melon"
                        expect(subject.items) == [
                            "Bob",
                            "Bobby",
                            "JR Bob Dobbs",
                            "Bob the Hoojah Melon"
                        ]

                        subject.filterText = "^#[a-f0-9]+$"
                        expect(subject.items.count) == 1
                        expect(subject.items) == [
                            "#ff11ab"
                        ]
                    }
                }
            }
        }
    }
}
