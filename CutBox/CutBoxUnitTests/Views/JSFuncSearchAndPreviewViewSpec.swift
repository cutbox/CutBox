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
        describe("JSFuncSearchAndPreviewView") {
            let subject = JSFuncSearchAndPreviewView()

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

                it("allows key shortcut editing methods") {
                    useTextCommands
                        .forEach {
                            expect(subject.textView(subject.searchText, doCommandBy: $0)).to(beTrue())
                        }
                }

                context("handles key events") {
                    var result: SearchJSFuncViewEvents?
                    _ = subject.events.subscribe(onNext: { result = $0 })

                    it("Cmd+T cycle color themes") {
                        if let keyEvent = fakeKey(kVK_ANSI_T, [.command]) {
                            subject.keyDown(with: keyEvent)
                            expect(result) == .cycleTheme
                        } else {
                            fail("Could not unwrap fake key event")
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
