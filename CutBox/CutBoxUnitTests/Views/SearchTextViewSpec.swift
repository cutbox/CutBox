//
//  SearchTextViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 17/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import Carbon

class SearchTextViewSpec: QuickSpec {
    override func spec() {
        describe("SearchTextView") {
            var subject: SearchTextView!

            beforeEach {
                let coder = mockCoder(for: NSView(frame: .zero))
                subject = SearchTextView(coder: coder!)
            }

            it("should be an instance of CutBoxBaseTextView") {
                expect(subject).to(beAKindOf(CutBoxBaseTextView.self))
            }

            context("when keyDown is called with a valid event") {
                it("should handle Cmd A") {
                    let keyEvent = fakeKey(kVK_ANSI_A, [.command])
                    subject.keyDown(with: keyEvent)
                    subject.doCommand(by: Selector(("noop:")))
                    expect(subject.keyDownEvent) == keyEvent
                }

                it("should handle Cmd X") {
                    let keyEvent = fakeKey(kVK_ANSI_X, [.command])
                    subject.keyDown(with: keyEvent)
                    subject.doCommand(by: Selector(("noop:")))
                    expect(subject.keyDownEvent) == keyEvent
                }

                it("should handle Cmd C") {
                    let keyEvent = fakeKey(kVK_ANSI_C, [.command])
                    subject.keyDown(with: keyEvent)
                    subject.doCommand(by: Selector(("noop:")))
                    expect(subject.keyDownEvent) == keyEvent
                }

                it("should handle Cmd V") {
                    let keyEvent = fakeKey(kVK_ANSI_V, [.command])
                    subject.keyDown(with: keyEvent)
                    subject.doCommand(by: Selector(("noop:")))
                    expect(subject.keyDownEvent) == keyEvent
                }
            }

            context("when doCommand is called with a selector") {
                it("should handle specific command selectors correctly") {
                    expect {
                        subject.doCommand(by: #selector(NSStandardKeyBindingResponding.moveLeft(_:)))
                    }.toNot(throwAssertion())

                    expect {
                        subject.doCommand(by: #selector(NSStandardKeyBindingResponding.moveDown(_:)))
                    }.toNot(throwAssertion())
                }
            }
        }
    }
}
