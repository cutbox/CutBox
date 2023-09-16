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
                SearchAndPreviewViewBase.testing = true

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
                    jsFuncService: mockJSFuncService,
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

                it("should apply the current theme") {
                    subject.jsFuncView.applyTheme()
                    expect { subject.jsFuncView.applyTheme() }.toNot(throwAssertion())
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
        }
    }
}
