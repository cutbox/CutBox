//
//  SearchViewControllerSpec.swift
//  CutBoxTests
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Quick
import Nimble

@testable import CutBox

class PasteboardServiceMock: PasteboardService {

    override init() {
        super.init()
        self.defaults = UserDefaults(suiteName: "FakeDefaults")!
    }

    var timerStarted = false

    override func startTimer() {
        timerStarted = true
    }

    override var items: [String] {
        get {
            return [
                "Fakes",
                "You're a fake baby, you can't conceal it, Know how I know, 'cause I can feel it.",
                "To kill a mockingbird"
            ]
        }
    }
}

fileprivate class CutBoxPreferencesMock: CutBoxPreferences {

    var fakeUseJoinStrings: Bool = false

    override var useJoinString: Bool {
        get {
            return fakeUseJoinStrings
        }
        set {
            fakeUseJoinStrings = newValue
        }
    }

    var fakeMultiJoinString: String? = nil

    override var multiJoinString: String? {
        get {
            return fakeMultiJoinString
        }
        set {
            fakeMultiJoinString = newValue
        }
    }

    var fakeUseWrappingStrings: Bool = false

    override var useWrappingStrings: Bool {
        get {
            return fakeUseWrappingStrings
        }
        set {
            fakeUseWrappingStrings = newValue
        }
    }

    var fakeWrappingStrings: (String?, String?) = (nil, nil)

    override var wrappingStrings: (String?, String?) {
        get {
            return fakeWrappingStrings
        }
        set {
            fakeWrappingStrings = newValue
        }
    }
}

class SearchViewControllerSpec: QuickSpec {
    override func spec() {
        describe("SearchViewController") {
            var pasteboardMock: PasteboardServiceMock!
            var prefsMock: CutBoxPreferencesMock!
            var subject:  SearchViewController!
            var tableView: NSTableView!

            beforeEach {
                pasteboardMock = PasteboardServiceMock()
                prefsMock = CutBoxPreferencesMock()
                subject = SearchViewController(
                    pasteboardService: pasteboardMock,
                    cutBoxPreferences: prefsMock
                )
                tableView = subject.searchView.clipboardItemsTable!
            }

            it("presents rows for each item in the pasteboard service store") {
                let rows = subject.numberOfRows(in: tableView)
                expect(rows).to(equal(3))
            }

            it("sets the row height of clip items") {
                let height = subject.tableView(tableView, heightOfRow: 0)
                expect(height).to(equal(30))
            }

            // TODO: probably makes sense to have this joining
            // functionality as part of the PasteboardService
            context("multiple clips") {
                context("default behavior") {
                    it("joins multiple clips by newlines") {
                        let joined = subject.prepareClips(pasteboardMock[[0,2]])
                        expect(joined).to(equal("Fakes\nTo kill a mockingbird"))
                    }
                }

                context("joined by string") {
                    context("nil string") {
                        it("joins each item with nothing between them") {
                            prefsMock.fakeUseJoinStrings = true
                            let joined = subject.prepareClips(pasteboardMock[[0,2]])
                            expect(joined).to(equal("FakesTo kill a mockingbird"))
                        }
                    }

                    context("has join string (comma)") {
                        it("joins each item with a comma") {
                            prefsMock.fakeUseJoinStrings = true
                            prefsMock.fakeMultiJoinString = ","
                            let joined = subject.prepareClips(pasteboardMock[[0,2]])
                            expect(joined).to(equal("Fakes,To kill a mockingbird"))
                        }
                    }
                }

                context("wrapped") {
                    context("nil strings") {
                        it("surrounds the joined strings with nothing") {
                            prefsMock.fakeUseWrappingStrings = true
                            prefsMock.fakeWrappingStrings = (nil, nil)
                            let wrapped = subject.prepareClips(pasteboardMock[[0,2]])
                            let expected = "Fakes\nTo kill a mockingbird"
                            expect(wrapped).to(equal(expected))
                        }
                    }
                    context("using strings") {
                        it("surrounds the joined strings with start and end strings") {
                            prefsMock.fakeUseWrappingStrings = true
                            prefsMock.fakeWrappingStrings = ("[", "]")
                            let wrapped = subject.prepareClips(pasteboardMock[[0,2]])
                            let expected = "[Fakes\nTo kill a mockingbird]"
                            expect(wrapped).to(equal(expected))
                        }
                    }
                }
            }
        }
    }
}
