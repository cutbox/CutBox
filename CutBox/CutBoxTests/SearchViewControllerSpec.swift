//
//  SearchViewControllerSpec.swift
//  CutBoxTests
//
//  Created by Jason on 12/4/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Quick
import Nimble

@testable import CutBox

class HistoryServiceMock: HistoryService {

    override init(defaults: UserDefaults) {
        super.init(defaults: defaults)
    }

    var timerStarted = false

    override func beginPolling() {
        timerStarted = true
    }

    override var items: [String] {
            return [
                "Fakes",
                "I can feel it.",
                "To kill a mockingbird"
            ]
    }
}

class SearchViewControllerSpec: QuickSpec {

    override func spec() {

        describe("SearchViewController") {

            var historyServiceMock: HistoryServiceMock!
            var subject: SearchViewController!
            var tableView: NSTableView!
            var defaults: UserDefaults!

            beforeEach {
                defaults = UserDefaultsMock()
                historyServiceMock = HistoryServiceMock(defaults: defaults)

                subject = SearchViewController(
                    pasteboardService: historyServiceMock
                )

                tableView = subject.searchView.itemsList!
            }

            afterEach {
                historyServiceMock.defaults.removeSuite(named: "FakeDefaults")
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
