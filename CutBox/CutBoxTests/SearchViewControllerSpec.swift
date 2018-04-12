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

class SearchViewControllerSpec: QuickSpec {

    override func spec() {

        describe("SearchViewController") {

            var pasteboardMock: PasteboardServiceMock!
            var subject:  SearchViewController!
            var tableView: NSTableView!

            beforeEach {
                pasteboardMock = PasteboardServiceMock()
                pasteboardMock.defaults = UserDefaults(suiteName: "FakeDefaults")!

                subject = SearchViewController(
                    pasteboardService: pasteboardMock
                )

                tableView = subject.searchView.clipboardItemsTable!
            }

            afterEach {
                pasteboardMock.defaults.removeSuite(named: "FakeDefaults")
            }

            it("presents rows for each item in the pasteboard service store") {
                let rows = subject.numberOfRows(in: tableView)
                expect(rows).to(equal(3))
            }

            it("sets the row height of clip items") {
                let height = subject.tableView(tableView, heightOfRow: 0)
                expect(height).to(equal(30))
            }
        }
    }
}
