//
//  ClipItemTableRowContainerViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 18/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

func fakeMouseEvent(with: NSEvent.EventType,
                    clickCount: Int,
                    modifierFlags: NSEvent.ModifierFlags = []) -> NSEvent {
    if let mouseEvent = NSEvent.mouseEvent(with: with,
                                           location: NSPoint(x: 0, y: 0),
                                           modifierFlags: modifierFlags,
                                           timestamp: 0,
                                           windowNumber: 0,
                                           context: nil,
                                           eventNumber: 0,
                                           clickCount: clickCount,
                                           pressure: 0) {
        return mouseEvent
    }
    fatalError("Unable to generate mouse event")
}

class ClipItemTableRowContainerViewSpec: QuickSpec {
    override func spec() {
        describe("ClipItemTableRowContainerView") {
            context("mouse events trigger search view events") {
                let searchView = SearchAndPreviewView(frame: .zero)
                let subject = ClipItemTableRowContainerView()
                var result: SearchViewEvents?

                beforeEach {
                    subject.searchView = searchView
                    _ = searchView.events.subscribe(onNext: {
                        result = $0
                    })
                }

                it("should double click to close and paste") {
                    let mouseEvent = fakeMouseEvent(with: .leftMouseDown,
                                                    clickCount: 2,
                                                    modifierFlags: [])
                    subject.mouseDown(with: mouseEvent)
                    expect(result) == .closeAndPasteSelected
                }

                it("should double click with control to use paste pipeline") {
                    let mouseEvent = fakeMouseEvent(with: .leftMouseDown,
                                                    clickCount: 2,
                                                    modifierFlags: [.control])
                    subject.mouseDown(with: mouseEvent)
                    expect(result) == .selectJavascriptFunction
                }

                it("should double click with control to use paste pipeline") {
                    let mouseEvent = fakeMouseEvent(with: .leftMouseDown,
                                                    clickCount: 2,
                                                    modifierFlags: [.control])
                    subject.mouseDown(with: mouseEvent)
                    expect(result) == .selectJavascriptFunction
                }

                it("should double right click to use paste pipeline") {
                    let mouseEvent = fakeMouseEvent(with: .rightMouseDown,
                                                    clickCount: 2)
                    subject.mouseDown(with: mouseEvent)
                    expect(result) == .selectJavascriptFunction
                }

                it("should double right click to use paste pipeline") {
                    let mouseEvent = fakeMouseEvent(with: .leftMouseDown,
                                                    clickCount: 1,
                                                    modifierFlags: [.command])
                    subject.mouseDown(with: mouseEvent)
                    expect(result) == .selectJavascriptFunction
                }

                it("should single click with option to toggle favorite") {
                    let mouseEvent = fakeMouseEvent(with: .leftMouseDown,
                                                    clickCount: 1,
                                                    modifierFlags: [.option])
                    subject.mouseDown(with: mouseEvent)
                    expect(result) == .toggleFavorite
                }
            }
        }
    }
}
