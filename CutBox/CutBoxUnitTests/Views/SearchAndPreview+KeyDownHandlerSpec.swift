//
//  SearchAndPreview+KeyDownHandlerSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 17/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import Carbon
import RxSwift

class SearchAndPreview_KeyDownHandlerSpec: QuickSpec {
    override func spec() {
        describe("SearchAndPreview+KeyDownHandler") {
            let subject = SearchAndPreviewView(frame: .zero)
            var result: SearchViewEvents?
            _ = subject.events.subscribe(onNext: { result = $0 })

            context("handles key events") {
                sharedExamples("keyboard event handling") { (context: @escaping SharedExampleContext) in
                    if let expectedOutcome = context()["expected"] as? SearchViewEvents,
                       let keyEvent = context()["key_event"] as? NSEvent,
                       let title = context()["title"] as? String {
                        it("\(title)") {
                            subject.keyDown(with: keyEvent)
                            expect(result) == expectedOutcome
                        }
                    }
                }

                itBehavesLike("keyboard event handling") {[
                    "title": "Ctrl+G just close",
                    "expected": SearchViewEvents.justClose,
                    "key_event": fakeKeyEvent(kVK_ANSI_G, [.control])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+t cycle color themes",
                    "expected": SearchViewEvents.cycleTheme,
                    "key_event": fakeKeyEvent(kVK_ANSI_T, [.command])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "RETURN close and paste selected",
                    "expected": SearchViewEvents.closeAndPasteSelected,
                    "key_event": fakeKeyEvent(kVK_Return)
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+RETURN select JS Function",
                    "expected": SearchViewEvents.selectJavascriptFunction,
                    "key_event": fakeKeyEvent(kVK_Return, [.command])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "ESC just close",
                    "expected": SearchViewEvents.justClose,
                    "key_event": fakeKeyEvent(kVK_Escape)
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Ctrl+G just close",
                    "expected": SearchViewEvents.justClose,
                    "key_event": fakeKeyEvent(kVK_ANSI_G, [.control])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+, open preferences",
                    "expected": SearchViewEvents.openPreferences,
                    "key_event": fakeKeyEvent(kVK_ANSI_Comma, [.command])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+, open preferences",
                    "expected": SearchViewEvents.openPreferences,
                    "key_event": fakeKeyEvent(kVK_ANSI_Comma, [.command])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+H toggle time filter",
                    "expected": SearchViewEvents.toggleTimeFilter,
                    "key_event": fakeKeyEvent(kVK_ANSI_H, [.command])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+[ toggle wrapping strings",
                    "expected": SearchViewEvents.toggleWrappingStrings,
                    "key_event": fakeKeyEvent(kVK_ANSI_LeftBracket, [.command])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+- toggle join strings",
                    "expected": SearchViewEvents.toggleJoinStrings,
                    "key_event": fakeKeyEvent(kVK_ANSI_Minus, [.command])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+Shift+0 scale text normalize",
                    "expected": SearchViewEvents.scaleTextNormalize,
                    "key_event": fakeKeyEvent(kVK_ANSI_0, [.command, .shift])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+Shift+- scale text down",
                    "expected": SearchViewEvents.scaleTextDown,
                    "key_event": fakeKeyEvent(kVK_ANSI_Minus, [.command, .shift])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+Shift+= scale text up",
                    "expected": SearchViewEvents.scaleTextUp,
                    "key_event": fakeKeyEvent(kVK_ANSI_Equal, [.command, .shift])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+F toggle search scope",
                    "expected": SearchViewEvents.toggleSearchScope,
                    "key_event": fakeKeyEvent(kVK_ANSI_F, [.command])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+S toggle search mode",
                    "expected": SearchViewEvents.toggleSearchMode,
                    "key_event": fakeKeyEvent(kVK_ANSI_S, [.command])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+Delete remove selected",
                    "expected": SearchViewEvents.removeSelected,
                    "key_event": fakeKeyEvent(kVK_Delete, [.command])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+Shift+Delete clear history",
                    "expected": SearchViewEvents.clearHistory,
                    "key_event": fakeKeyEvent(kVK_Delete, [.command, .shift])
                ]}

                itBehavesLike("keyboard event handling") {[
                    "title": "Cmd+P toggle preview",
                    "expected": SearchViewEvents.togglePreview,
                    "key_event": fakeKeyEvent(kVK_ANSI_P, [.command])
                ]}

                it("Handles Up and Down arrows as table row navigation") {
                    class MockTableView: NSTableView {
                        var keyDownMock: NSEvent?

                        override func keyDown(with event: NSEvent) {
                            keyDownMock = event
                        }
                    }

                    if let keyEvent = fakeKeyEvent(kVK_UpArrow) {
                        let mockTableView = MockTableView()
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
