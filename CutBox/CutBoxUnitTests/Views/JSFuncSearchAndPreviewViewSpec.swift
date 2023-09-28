//
//  JSFuncSearchAndPreviewViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 16/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import RxSwift
import Carbon

class JSFuncSearchAndPreviewViewSpec: QuickSpec {
    override func spec() {
        var subject: JSFuncSearchAndPreviewView!
        let mainContainer = CutBoxBaseStackView()
        let container = CutBoxBaseStackView()
        let mainTopConstraint = NSLayoutConstraint()
        let mainLeadingConstraint = NSLayoutConstraint()
        let mainTrailingConstraint = NSLayoutConstraint()
        let mainBottomConstraint = NSLayoutConstraint()
        let searchTextContainerHeight = NSLayoutConstraint()
        let timeFilterLabel = CutBoxBaseTextField()
        let mockDefaults = UserDefaultsMock()
        let mockPrefs = CutBoxPreferencesService(defaults: mockDefaults)

        beforeEach {
            subject = JSFuncSearchAndPreviewView()
            subject.prefs = mockPrefs
            subject.mainContainer = mainContainer
            subject.container = container
            subject.searchTextContainerHeight = searchTextContainerHeight
            subject.mainTopConstraint = mainTopConstraint
            subject.mainLeadingConstraint = mainLeadingConstraint
            subject.mainTrailingConstraint = mainTrailingConstraint
            subject.mainBottomConstraint = mainBottomConstraint
        }

        describe("JSFuncSearchAndPreviewView") {

            describe("Search text view delegate") {
                let mockSearchText = SearchTextView(frame: .zero, textContainer: .none)

                beforeEach {
                    subject.searchText = mockSearchText
                    subject.searchText.string = "TESTING"
                }

                it("notifies subscribers when text changes") {
                    var result: String = ""
                    _ = subject.filterTextPublisher.subscribe(onNext: {
                        result = $0
                    })
                    let notification = Notification(name: NSTextField.textDidChangeNotification,
                                                    object: subject.searchText)
                    subject.textDidChange(notification)
                    expect(result) == subject.searchText.string
                }

                it("applies the theme") {
                    expect {
                        subject.applyTheme()
                    }.toNot(throwAssertion())
                }

                it("reload js throws an exception when view is not connected") {
                    expect {
                        subject.reloadJS(CutBoxBaseMenuItem())
                    }.to(throwAssertion())
                }

                it("allows key shortcut editing methods") {
                    useTextCommands
                        .forEach {
                            expect(subject.textView(subject.searchText, doCommandBy: $0)).to(beTrue())
                        }
                }

                context("handles key events") {
                    var result: SearchJSFuncViewEvents?

                    beforeEach {
                        _ = subject.events.subscribe(onNext: { result = $0 })
                    }

                    it("Cmd+T cycle color themes") {
                        if let keyEvent = fakeKey(kVK_ANSI_T, [.command]) {
                            subject.keyDown(with: keyEvent)
                            expect(result) == .cycleTheme
                        } else {
                            fail("Could not unwrap fake key event")
                        }
                    }

                    it("just closes on Esc") {
                        if let keyEvent = fakeKey(kVK_Escape, [.command]) {
                            subject.keyDown(with: keyEvent)
                            expect(result) == .justClose
                        } else {
                            fail("Could not unwrap fake key event")
                        }
                    }

                    it("handles default") {
                        if let keyEvent = fakeKey(kVK_F1, [.command]) {
                            expect {
                                subject.keyDown(with: keyEvent)
                            }.toNot(throwAssertion())
                        }
                    }

                    it("RETURN close and paste") {
                        if let keyEvent = fakeKey(kVK_Return) {
                            subject.keyDown(with: keyEvent)
                            expect(result) == .closeAndPaste
                        } else {
                            fail("Could not unwrap fake key event")
                        }
                    }

                    it("Handles Up and Down arrows as table row navigation") {
                        class MockTableView: NSTableView {
                            var keyDownMock: NSEvent?

                            override func keyDown(with event: NSEvent) {
                                keyDownMock = event
                            }
                        }

                        class MockJSFuncService: JSFuncService {
                            var isEmptyCalled = false
                            override var isEmpty: Bool {
                                isEmptyCalled = true
                                return false
                            }
                        }

                        if let keyEvent = fakeKey(kVK_UpArrow) {
                            let mockJs = MockJSFuncService()
                            let mockTableView = MockTableView()
                            subject.js = mockJs
                            subject.itemsList = mockTableView
                            subject.keyDown(with: keyEvent)
                            expect(mockTableView.keyDownMock) == keyEvent
                        } else {
                            fail("Could not unwrap fake key event")
                        }
                    }
                }
            }
        }
    }
}
