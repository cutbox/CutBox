//
//  JSFuncSearchViewControllerSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 15/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import RxSwift

class JSFuncSearchViewControllerSpec: QuickSpec {
    class MockJSFuncSearchAndPreviewView: JSFuncSearchAndPreviewView {}

    class MockJSFuncService: JSFuncService {
        var processReturn: String = "JSFunc Service Testing Mock"
        override func process(_ name: String, items: [String]) -> String {
            return processReturn
        }

        override var funcList: [String] {
            ["fake"]
        }
    }

    class MockTableView: NSTableView {
        var selectRowMock = 0
        override var selectedRow: Int {
            return selectRowMock
        }
    }

    override func spec() {
        describe("JSFuncSearchViewController") {
            var subject: JSFuncSearchViewController!
            var mockUserDefaults: UserDefaultsMock!
            var prefs: CutBoxPreferencesService!
            var mockPasteboard: PasteboardWrapperType!
            var mockFakeKey: FakeKey!
            var mockJSFuncService: MockJSFuncService!
            var mockJSFuncView: JSFuncSearchAndPreviewView!
            var mockItemsList: MockTableView!
            let mockSearchScopeImageButton = CutBoxBaseButton()

            beforeEach {
                FakeKey.testing = true

                mockJSFuncService = MockJSFuncService()
                mockUserDefaults = UserDefaultsMock()
                prefs = CutBoxPreferencesService(defaults: mockUserDefaults)
                mockFakeKey = FakeKey()
                mockJSFuncView = MockJSFuncSearchAndPreviewView()
                mockItemsList = MockTableView()
                mockJSFuncView.itemsList = mockItemsList
                mockJSFuncView.searchScopeImageButton = mockSearchScopeImageButton
                mockPasteboard = MockPasteboardWrapper()

                subject = JSFuncSearchViewController(
                    js: mockJSFuncService,
                    cutBoxPreferences: prefs,
                    fakeKey: mockFakeKey,
                    jsFuncView: mockJSFuncView,
                    pasteboard: mockPasteboard
                )
            }

            context("when initialized") {
                it("should have the correct initial properties") {
                    expect(subject.jsFuncView.searchScopeImageButton).toNot(beNil())
                    expect(subject.hasFuncs).to(beTrue())
                    expect(subject.count) == 1
                    expect(subject.selectedClips).toNot(beNil())
                }
            }

            context("when configured") {
                it("should have a funcList") {
                    expect(subject.funcList).toNot(beNil())
                }

                it("should configure JS popup and view correctly") {
                    expect(subject.jsFuncPopup).toNot(beNil())
                }

                it("should set up search text event bindings") {
                    expect(subject.events.hasObservers).to(beTrue())
                }

                it("has a search view that can become first responder") {
                    expect(subject.jsFuncView.acceptsFirstResponder).to(beTrue())
                }
            }

            describe("pasteSelectedClips") {
                let clips = ["Bob", "David"]
                beforeEach {
                    subject.selectedClips = clips
                }

                it("pastes the selected clips to the clipboard, via the selected JS function") {
                    mockItemsList.selectRowMock = 0
                    subject.pasteSelectedClips()
                    let result = mockPasteboard.pasteboardItems?.first?.string(forType: .string)
                    expect(result) == "JSFunc Service Testing Mock"
                }

                it("pastes the selected clips to the clipboard, bypassing any function") {
                    mockItemsList.selectRowMock = -1
                    subject.pasteSelectedClips()
                    let result = mockPasteboard.pasteboardItems?.first?.string(forType: .string)
                    expect(result) == "Bob\nDavid"
                }
            }

            describe("setupSearchTextEventBindings") {
                context("events") {
                    it("handles closeAndPaste") {
                        subject.events.onNext(.closeAndPaste)
                        expect(subject.jsFuncView.isHidden).to(beTrue())
                    }

                    it("handles justClose") {
                        subject.events.onNext(.justClose)
                        expect(subject.jsFuncView.isHidden).to(beTrue())
                    }

                    it("handles default") {
                        expect {
                            subject.events.onNext(.cycleTheme)
                        } .toNot(throwAssertion())
                    }
                }
            }

            describe("Table View Delegate") {
                let clips = ["Bob", "David"]

                beforeEach {
                    subject.selectedClips = clips
                }

                context("updateSearchItemPreview") {
                    it("sets the preview string") {
                        subject.updateSearchItemPreview()
                        expect(mockJSFuncService.processReturn) == "JSFunc Service Testing Mock"
                    }
                }

                context("tableViewSelectionDidChange") {
                    it("calls update search item preview") {
                        let notification = Notification(
                            name: NSTableView.selectionDidChangeNotification,
                            object: mockItemsList)
                        subject.tableViewSelectionDidChange(notification)
                        expect(mockJSFuncService.processReturn) == "JSFunc Service Testing Mock"
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
                        expect(result).to(beAnInstanceOf(JSFuncItemTableRowContainerView.self))
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
                            expect(cell).to(beAnInstanceOf(JSFuncItemTableRowImageView.self))
                        }
                    }
                    context("string column") {
                        it("should return a JSFuncItemTableRowTextView") {
                            let column = NSTableColumn(identifier: NSUserInterfaceItemIdentifier(rawValue: "string"))
                            let cell = subject.tableView(mockItemsList,
                                                         viewFor: column,
                                                         row: 0)
                            expect(cell).to(beAnInstanceOf(JSFuncItemTableRowTextView.self))
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
        }
    }
}
