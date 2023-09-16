//
//  SearchViewControllerSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 14/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import RxSwift

class SearchViewControllerSpec: QuickSpec {

    class MockHistoryService: HistoryService {
        var removeCalled = false
        override func remove(selected: IndexSet) {
            removeCalled = true
        }
    }

    override func spec() {
        describe("SearchViewController") {
            var subject: SearchViewController!
            var mockHistoryService: MockHistoryService!
            var mockCutBoxPreferences: CutBoxPreferencesService!
            var mockFakeKey: FakeKey!
            var mockSearchAndPreviewView: SearchAndPreviewView!
            var mockUserDefaults: UserDefaultsMock!
            var mockPasteboard: MockPasteboardWrapper!
            var mockItemsList: NSTableView!

            beforeEach {
                LoginItemsService.testing = true

                mockUserDefaults = UserDefaultsMock()
                mockPasteboard = MockPasteboardWrapper()
                mockHistoryService = MockHistoryService(defaults: mockUserDefaults, pasteboard: mockPasteboard)
                mockCutBoxPreferences = CutBoxPreferencesService(defaults: mockUserDefaults)
                mockFakeKey = FakeKey()
                mockSearchAndPreviewView = SearchAndPreviewView()
                mockItemsList = NSTableView()
                mockSearchAndPreviewView.itemsList = mockItemsList

                subject = SearchViewController(
                    historyService: mockHistoryService,
                    cutBoxPreferences: mockCutBoxPreferences,
                    fakeKey: mockFakeKey,
                    searchView: mockSearchAndPreviewView
                )
            }

            context("when initialized") {
                it("should have the correct dependencies") {
                    expect(subject.searchView).to(be(mockSearchAndPreviewView))
                    expect(subject.historyService).to(be(mockHistoryService))
                    expect(subject.prefs).to(be(mockCutBoxPreferences))
                    expect(subject.fakeKey).to(be(mockFakeKey))
                }

                it("should set up event bindings") {
                    expect(subject.events.hasObservers).to(beTrue())
                }
            }

            describe("Table View Delegate") {
                beforeEach {
                    mockHistoryService.migrateLegacyHistoryStore(["Bob", "David"], mockUserDefaults)
                }

                context("updateSearchItemPreview") {
                    it("sets the preview string") {
                        subject.updateSearchItemPreview()
                    }
                }

                context("tableViewSelectionDidChange") {
                    it("calls update search item preview") {
                        let notification = Notification(
                            name: NSTableView.selectionDidChangeNotification,
                            object: mockItemsList)
                        subject.tableViewSelectionDidChange(notification)
                    }
                }

                context("tableView heightOfRow") {
                    it("should return 30") {
                        expect(subject.tableView(mockItemsList, heightOfRow: 1)) == 30
                    }
                }

                context("tableView rowViewForRow") {
                    it("should return a JSFuncItemTableRowContainerView") {
                        let result = subject.tableView(mockItemsList, rowViewForRow: 1)
                        expect(result).to(beAnInstanceOf(ClipItemTableRowContainerView.self))
                    }
                }

                context("tableView selectionIndexesForProposedSelection") {
                    it("gets the selected indexes") {
                        let indexes = subject.tableView(mockItemsList,
                                                        selectionIndexesForProposedSelection:
                                                            IndexSet(integer: 1))
                        expect(indexes.count) == 1
                    }
                }

                context("tableView tableColumnView") {
                    context("icon column") {
                        it("should return a JSFuncItemTableRowImageView") {
                            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "icon"))
                            let cell = subject.tableView(mockItemsList,
                                                         viewFor: column,
                                                         row: 0)
                            expect(cell).to(beAnInstanceOf(ClipItemTableRowImageView.self))
                        }
                    }
                    context("string column") {
                        it("should return a JSFuncItemTableRowTextView") {
                            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "string"))
                            let cell = subject.tableView(mockItemsList,
                                                         viewFor: column,
                                                         row: 0)
                            expect(cell).to(beAnInstanceOf(ClipItemTableRowTextView.self))
                        }
                    }

                    context("default") {
                        it("should return nil") {
                            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "foobar"))
                            let cell = subject.tableView(mockItemsList,
                                                         viewFor: column,
                                                         row: 0)
                            expect(cell).to(beNil())
                        }
                    }
                }
            }

            context("SearchViewEvents") {
                context("scaleTextUp") {
                    it("increases clip and preview font sizes") {
                        subject.onNext(event: .scaleTextUp)
                        expect(subject.prefs.searchViewClipTextFieldFont?.pointSize) == 13
                        expect(subject.prefs.searchViewClipPreviewFont?.pointSize) == 13
                    }
                }

                context("scaleTextDown") {
                    it("decreases clip and preview font sizes") {
                        subject.prefs.searchViewClipTextFieldFont = NSFont(name: "Helvetica Neue", size: 14)
                        subject.prefs.searchViewClipPreviewFont = NSFont(name: "Menlo", size: 14)

                        subject.onNext(event: .scaleTextDown)

                        expect(subject.prefs.searchViewClipTextFieldFont?.pointSize) == 13
                        expect(subject.prefs.searchViewClipPreviewFont?.pointSize) == 13
                    }
                }

                context("scaleTextNormalize") {
                    it("resets clip and preview font sizes to default") {
                        subject.prefs.searchViewClipTextFieldFont = NSFont(name: "Helvetica Neue", size: 18)
                        subject.prefs.searchViewClipPreviewFont = NSFont(name: "Menlo", size: 18)

                        subject.onNext(event: .scaleTextNormalize)

                        expect(subject.prefs.searchViewClipTextFieldFont?.pointSize) == 12
                        expect(subject.prefs.searchViewClipPreviewFont?.pointSize) == 12
                    }
                }

                context("setSearchMode") {
                    it("sets the search mode on history service") {
                        subject.onNext(event: .setSearchMode(.regexpAnyCase))
                        expect(subject.historyService.searchMode) == .regexpAnyCase
                    }
                }

                context("setSearchMode") {
                    it("sets the search mode on history service") {
                        subject.onNext(event: .toggleSearchMode)
                        expect(subject.historyService.searchMode) == .regexpAnyCase
                        subject.onNext(event: .toggleSearchMode)
                        expect(subject.historyService.searchMode) == .regexpStrictCase
                    }
                }

                context("setTimeFilter") {
                    it("sets the time linit filter on history service") {
                        subject.onNext(event: .setTimeFilter(seconds: 10))
                        expect(subject.historyService.historyRepo.timeFilter) == 10.0
                    }
                }

                context("toggleTimeFilter") {
                    it("clears and resets the time linit filter on history") {
                        subject.onNext(event: .toggleTimeFilter)
                        expect(subject.historyService.historyRepo.timeFilter).to(beNil())
                    }
                }

                context("cycleTheme") {
                    it("clears and resets the time linit filter on history") {
                        subject.onNext(event: .cycleTheme)
                        expect(subject.prefs.currentTheme.name) == "Skylight"
                    }
                }

                context("toggleWrappingStrings") {
                    it("toggle wrapping strings on / off") {
                        subject.onNext(event: .toggleWrappingStrings)
                        expect(subject.prefs.useWrappingStrings).to(beTrue())
                    }
                }

                context("toggleJoinStrings") {
                    it("toggle join strings on / off") {
                        subject.onNext(event: .toggleJoinStrings)
                        expect(subject.prefs.useJoinString).to(beTrue())
                    }
                }

                context("toggleSearchScope") {
                    it("toggle favorite search scope only on / off") {
                        subject.onNext(event: .toggleSearchScope)
                        expect(subject.historyService.favoritesOnly).to(beTrue())
                    }
                }

                context("togglePreview") {
                    it("toggle preview on / off") {
                        subject.onNext(event: .togglePreview)
                        expect(subject.prefs.hidePreview).to(beTrue())
                    }
                }

                context("toggleFavorite") {
                    it("toggles favorites onlyon / off") {
                        subject.searchView = mockSearchAndPreviewView
                        subject.onNext(event: .toggleFavorite)
                    }
                }

                context("justClose") {
                    it("close cutbox popup") {
                        subject.onNext(event: .justClose)
                        expect(subject.searchPopup.isOpen) == false
                    }
                }

                context("closeAndPasteSelected") {
                     it("close cutbox and paste") {
                        FakeKey.testing = true
                        FakeKey.testResult = []

                        subject.onNext(event: .closeAndPasteSelected)
                        expect(subject.searchPopup.isOpen) == false
                        expect(FakeKey.testResult.count)
                            .toEventually(
                                equal(2),
                                pollInterval: .milliseconds(275))

                        FakeKey.testResult = []
                    }
                }

                context("removeSelected") {
                    it("remove selected items from history") {
                        let mockTableView = NSTableView()
                        mockTableView.selectRowIndexes(IndexSet(integer: 0),
                                                       byExtendingSelection: false)

                        subject.searchView.itemsList = mockTableView

                        subject.onNext(event: .removeSelected)
                        expect(mockHistoryService.removeCalled).to(beTrue())
                    }
                }
            }
        }
    }
}
