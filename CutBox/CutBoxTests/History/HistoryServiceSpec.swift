//
//  HistoryServiceSpec.swift
//  CutBoxTests
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import CutBox

fileprivate class HistoryRepoMock: HistoryRepo {

}

fileprivate class PasteboardWrapperMock: PasteboardWrapperType {
    var pasteboardItems: [NSPasteboardItem]?

    func addToFakePasteboard(string: String) {
        let item = NSPasteboardItem(pasteboardPropertyList: string, ofType: .string)!
        pasteboardItems?.insert(item, at: 0)
    }

    init() {
        pasteboardItems = []
    }
}

fileprivate func addToFakePasteboardAndPoll(string: String,
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
            "Relatively complicated and doesn't fuzzy match with anything else, of this I'm sure.",
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
            expect(subject.count).to(equal(0))
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

                expect(clipboardContent).to(equal("Example"))
            }

            it("stores clipboard content") {
                expect(subject.count).to(equal(17))
                expect(subject.items.first).to(equal("Example"))
            }

            it("can clear its storage") {
                expect(subject.count).to(equal(17))

                subject.clear()

                expect(subject.count).to(equal(0))
            }

            context("duplicate handling") {
                it("removes duplicate items and inserts them as first history item") {
                    expect(subject.items.count).to(equal(17))

                    addToFakePasteboardAndPoll(string: "JR Bob Dobbs",
                                               subject: subject,
                                               pboard: mockPasteboard)

                    expect(subject.items.count).to(equal(17))
                    expect(subject.items.first).to(equal("JR Bob Dobbs"))
                }
            }

            context("history limit set") {
                it("truncates the history to the history limit") {
                    subject.historyLimit = 10
                    expect(subject.items.count).to(equal(10))

                    subject.historyLimit = 13
                    expect(subject.items.count).to(equal(10))
                }

                it("adds items and removes oldest item") {
                    subject.historyLimit = 10
                    expect(subject.items.count).to(equal(10))

                    addToFakePasteboardAndPoll(string: "New New News",
                                               subject: subject,
                                               pboard: mockPasteboard)

                    expect(subject.items.count).to(equal(10))
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
                        expect(subject.items).to(equal([
                            "#FF0022",
                            "FF443211",
                            "39124741"
                            ]))

                        subject.filterText = "Complicated"
                        expect(subject.items).to(equal([
                            "Relatively complicated and doesn't fuzzy match with anything else, of this I'm sure."
                            ]))

                        subject.filterText = "Bob"
                        expect(subject.items).to(equal([
                            "Bob",
                            "Bobby",
                            "Boost boost",
                            "Bob the Hoojah Melon",
                            "JR Bob Dobbs",
                            "Robobt"
                            ]))
                    }
                }

                context("regexp") {
                    context("case insensitive") {
                        beforeEach {
                            subject.searchMode = .regexpAnyCase
                        }

                        it("filters regexp matches") {
                            subject.filterText = "Bob"
                            expect(subject.items).to(equal([
                                "Bob",
                                "Robobt",
                                "Bobby",
                                "JR Bob Dobbs",
                                "Bob the Hoojah Melon"
                                ]))

                            subject.filterText = "^#[a-f0-9]+$"
                            expect(subject.items).to(equal([
                                "#FF0022",
                                "#ff11ab"
                                ]))
                        }
                    }
                    context("case sensitive") {
                        beforeEach {
                            subject.searchMode = .regexpStrictCase
                        }

                        it("filters case sensitive regexp matches") {
                            subject.filterText = "Bob"
                            expect(subject.count).to(equal(4))
                            expect(subject.items.last).to(equal("Bob the Hoojah Melon"))
                            expect(subject.items).to(equal([
                                "Bob",
                                "Bobby",
                                "JR Bob Dobbs",
                                "Bob the Hoojah Melon"
                                ]))

                            subject.filterText = "^#[a-f0-9]+$"
                            expect(subject.items.count).to(equal(1))
                            expect(subject.items).to(equal([
                                "#ff11ab"
                                ]))
                        }
                    }
                }
            }
        }
    }
}
