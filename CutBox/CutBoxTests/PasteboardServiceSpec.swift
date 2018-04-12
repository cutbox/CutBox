//
//  PasteboardServiceSpec.swift
//  CutBoxTests
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Quick
import Nimble

@testable import CutBox

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
                                            subject: PasteboardService,
                                            pboard: PasteboardWrapperMock) {
    pboard.addToFakePasteboard(string: string)
    subject.pollPasteboard()
}

class PasteboardServiceSpec: QuickSpec {
    override func spec() {
        let subject: PasteboardService = PasteboardService()
        let mockPasteboard = PasteboardWrapperMock()
        let defaults = UserDefaults(suiteName: "PasteboardServiceSpec")!

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
            subject.defaults = defaults
            subject.pasteboard = mockPasteboard
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

            it("can clear it's storage") {
                expect(subject.count).to(equal(17))

                subject.clear()

                expect(subject.count).to(equal(0))
            }

            it("saves storage to user defaults") {
                expect(defaults.array(forKey: "pasteStore") as? [String])
                    .to(equal(fakeItems.reversed()))
            }

            context("searching") {
                context("fuzzy match") {
                    beforeEach {
                        subject.searchMode = .fuzzyMatch
                    }

                    it("sorts/filters items based on how closely they match") {
                        // (length difference is an ordering factor)

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

                            subject.filterText = "^#?[a-f0-9]+$"
                            expect(subject.items).to(equal([
                                "#FF0022",
                                "#ff11ab",
                                "FF443211",
                                "39124741"
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

                            subject.filterText = "^#?[a-f0-9]+$"
                            expect(subject.items.count).to(equal(2))
                            expect(subject.items.last).to(equal("39124741"))
                            expect(subject.items).to(equal([
                                "#ff11ab",
                                "39124741"
                                ]))
                        }
                    }
                }
            }
        }
    }
}
