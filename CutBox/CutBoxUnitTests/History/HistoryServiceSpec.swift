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
    var called = false
    var _pasteboardItems: [NSPasteboardItem]?
    var pasteboardItems: [NSPasteboardItem]? {
        get {
            called = true
            return _pasteboardItems
        }
    }

    func addToFakePasteboard(string: String) {
        let item = NSPasteboardItem(pasteboardPropertyList: string, ofType: .string)!
        _pasteboardItems?.insert(item, at: 0)
    }

    init() {
        _pasteboardItems = []
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
        var mockDefaults: UserDefaultsMock!
        var mockPrefs: CutBoxPreferencesService!

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
            mockDefaults = UserDefaultsMock()
            mockPasteboard = PasteboardWrapperMock()
        }

        context("pasteStore") {
            context("legacy store migration 1.x") {
                it("converts a legacy store") {
                    // fakeLegacyStore
                    mockDefaults.set(fakeItems, forKey: "pasteStore")

                    mockPrefs = CutBoxPreferencesService(defaults: mockDefaults)
                    mockHistoryRepo = HistoryRepoMock(defaults: mockDefaults,
                                                      prefs: mockPrefs)

                    expect(mockDefaults.array(forKey: "pasteStore") as? [String]) == fakeItems

                    subject = HistoryService(defaults: mockDefaults,
                                             pasteboard: mockPasteboard,
                                             historyRepo: mockHistoryRepo,
                                             prefs: mockPrefs)

                    expect(subject.defaults) == mockDefaults
                    expect(mockDefaults.array(forKey: "pasteStore") as? [String]).to(beNil())

                    if let resultItems: [[String: String]] = (mockDefaults.array(forKey: "historyStore") as? [[String: String]]) {
                        expect(resultItems.count) == fakeItems.count
                        let extracted: [String] = resultItems.map { $0["string"]! }
                        expect(extracted) == fakeItems
                    } else {
                        fail()
                    }
                }
            }
        }

        context("historyStore") {
            beforeEach {
                mockPrefs = CutBoxPreferencesService(defaults: mockDefaults)
                mockHistoryRepo = HistoryRepoMock(defaults: mockDefaults,
                                                  prefs: mockPrefs)

                subject = HistoryService(defaults: mockDefaults,
                                         pasteboard: mockPasteboard,
                                         historyRepo: mockHistoryRepo,
                                         prefs: mockPrefs)
            }

            it("starts with an empty pasteboard") {
                expect(subject.count) == 0
            }

            describe("toggleSearchMode") {
                it("switches through available search modes") {
                    subject.searchMode = .substringMatch
                    subject.toggleSearchMode()
                    expect(subject.searchMode) == .fuzzyMatch
                }
            }

            describe("toggle favorite") {
                it("toggles the favorite state of an item") {
                    ["bob", "david"].forEach {
                        addToFakePasteboardAndPoll(string: $0,
                                                   subject: subject,
                                                   pboard: mockPasteboard)
                    }
                    expect(subject.count) == 2
                    subject.toggleFavorite(items: IndexSet(integer: 0))
                    subject.favoritesOnly = true
                    expect(subject.count) == 1
                }
            }

            describe("clearWithTimestampPredicate") {
                it("clears all the items matched by the predicate") {
                    mockHistoryRepo.insert("an hour ago",
                                           isFavorite: false,
                                           date: Date(timeIntervalSinceNow: -3600))
                    mockHistoryRepo.insert("less than 30 seconds ago",
                                           isFavorite: false,
                                           date: Date(timeIntervalSinceNow: -29))
                    expect(subject.items.count) == 2

                    let predicate: (String) -> Bool = historyOffsetPredicateFactory(offset: 30.0) // up to 30 seconds ago
                    subject.clearWithTimestampPredicate(predicate: predicate)

                    expect(subject.items) == ["an hour ago"]
                }

                it("respects the setting of protect favorites") {
                    mockHistoryRepo.insert("an hour ago",
                                           isFavorite: false,
                                           date: Date(timeIntervalSinceNow: -3600))
                    mockHistoryRepo.insert("less than 30 seconds ago",
                                           isFavorite: true,
                                           date: Date(timeIntervalSinceNow: -29))
                    expect(subject.items.count) == 2
                    mockPrefs.protectFavorites = true

                    let predicate: (String) -> Bool = historyOffsetPredicateFactory(offset: 30.0) // up to 30 seconds ago
                    subject.clearWithTimestampPredicate(predicate: predicate)

                    expect(subject.items.count) == 2
                }
            }

            describe("setTimeFilter") {
                it("filters items by time") {
                    mockHistoryRepo.insert("an hour ago",
                                           isFavorite: false,
                                           date: Date(timeIntervalSinceNow: -3600))
                    mockHistoryRepo.insert("less than 30 seconds ago",
                                           isFavorite: true,
                                           date: Date(timeIntervalSinceNow: -29))
                    expect(subject.items.count) == 2

                    subject.setTimeFilter(seconds: 10)
                    expect(subject.items.count) == 0

                    subject.setTimeFilter(seconds: 30)
                    expect(subject.items.count) == 1
                }
            }

            describe("historyMemorySize") {
                beforeEach {
                    1024.doTimes { mockHistoryRepo.insert("Not much \($0)") }
                }

                it("reports the history size in memory units") {
                    expect(subject.historyMemorySize()) == "54 KB"
                }
            }

            describe("remove") {
                beforeEach {
                    ["bob", "david"].forEach {
                        addToFakePasteboardAndPoll(string: $0,
                                                   subject: subject,
                                                   pboard: mockPasteboard)
                    }

                    // populate cache
                    _ = subject.items
                    _ = subject.dict
                }
                it("removes an item") {
                    expect(subject.count) == 2
                    expect(subject.items[0]) == "david"

                    subject.remove(selected: IndexSet(integer: 0))
                    expect(subject.count) == 1
                    expect(subject.items[0]) == "bob"
                }

                it("removes an items") {
                    expect(subject.count) == 2
                    expect(subject.items[0]) == "david"
                    expect(subject.items[1]) == "bob"

                    subject.remove(selected: IndexSet(arrayLiteral: 0, 1))
                    expect(subject.count) == 0
                }
            }

            context("polling") {
                it("polls the pasteboard") {
                    expect(subject.pollingTimer).to(beNil())
                    subject.beginPolling()
                    expect(subject.pollingTimer).notTo(beNil())
                    expect(mockPasteboard.called).toEventually(
                        beTrue(),
                        pollInterval: .milliseconds(100))
                    subject.endPolling()
                }

                it("cannot start polling twice in a row") {
                    let timer = Timer(timeInterval: 0.01, repeats: false) { _ in _ = true }
                    subject.pollingTimer = timer

                    subject.beginPolling() // has a 200ms interval
                    expect(subject.pollingTimer) == timer
                }
            }

            describe("dict") {
                beforeEach {
                    fakeItems.forEach {
                        addToFakePasteboardAndPoll(string: $0,
                                                   subject: subject,
                                                   pboard: mockPasteboard)
                    }

                    // populate cache
                    _ = subject.dict
                    _ = subject.items
                    subject.filterText = nil
                }

                it("should match the order of .items") {
                    let result = subject.dict.map { $0["string"] }
                    let items = subject.items

                    expect(result[5]) == items[5]
                    expect(result[8]) == items[8]
                    expect(result[2]) == items[2]
                }

                it("will access cached dict of history items") {
                    expect(subject.dict.first?["string"]) == "Example"
                    expect(subject.dict.count) == 18
                }

                context("search modes") {
                    context("favorites only") {
                        it("return items marked as favorites only") {
                            subject.favoritesOnly = true
                            expect(subject.dict.count) == 0

                            mockHistoryRepo.insert("Favorite", isFavorite: true)
                            subject.invalidateCache()
                            expect(subject.dict.count) == 1
                        }
                    }

                    context("fuzzy") {
                        it("returns items matching a fuzzy search") {
                            subject.searchMode = .fuzzyMatch
                            subject.filterText = "2"
                            expect(subject.dict.count) == 3
                        }
                    }

                    context("regex") {
                        context("returns items matching a regex") {
                            it("can match a case sensitive regex") {
                                subject.searchMode = .regexpStrictCase
                                subject.filterText = "Bo.*b"
                                expect(subject.dict.count) == 5
                            }

                            it("can match a case insensitive regex") {
                                subject.searchMode = .regexpAnyCase
                                subject.filterText = "Bo.*b"
                                expect(subject.dict.count) == 6
                            }
                        }
                    }

                    context("exact") {
                        it("matches an exact substring") {
                            subject.searchMode = .substringMatch
                            subject.filterText = "Bo.*b"
                            expect(subject.dict.count) == 0
                            addToFakePasteboardAndPoll(string: "Bo.*b",
                                                       subject: subject,
                                                       pboard: mockPasteboard)
                            expect(subject.dict.count) == 1
                        }
                    }
                }
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
}
