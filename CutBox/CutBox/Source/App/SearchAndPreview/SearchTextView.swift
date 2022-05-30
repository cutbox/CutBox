//
//  SearchTextView.swift
//  CutBox
//
//  Created by Jason Milkins on 7/4/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

class SearchTextView: NSTextView {

    private var keyDownEvent: NSEvent?

    required init?(coder aCoder: NSCoder) {
        super.init(coder: aCoder)
    }

    override init(frame frameRect: NSRect, textContainer aTextContainer: NSTextContainer!) {
        super.init(frame: frameRect, textContainer: aTextContainer)
    }

    override func keyDown(with: NSEvent) {
        keyDownEvent = with
        super.keyDown(with: with)
    }

    private var augmentedSelectors: [Selector] { return [
        "moveRight:",
        "moveLeft:"
        ].map { Selector($0) }
    }

    private var skippedSelectors: [Selector] { return [
        "deleteToBeginningOfLine:",
        "moveUp:",
        "moveDown:",
        "moveDownAndModifySelection:",
        "moveUpAndModifySelection:",
        "insertNewline:",
        "noop:"
        ].map { Selector($0) }
    }

    // MARK: Pass through noop and specific keyboard events to nextResponder
    override func doCommand(by selector: Selector) {
        if let keyEvent = keyDownEvent {
            switch (keyEvent.key, keyEvent.modifiers) {
            case (kVK_ANSI_A, [.command]):
                self.selectAll(self)
                return

            case (kVK_ANSI_X, [.command]):
                self.cut(self)
                return

            case (kVK_ANSI_C, [.command]):
                self.copy(self)
                return

            case (kVK_ANSI_V, [.command]):
                self.paste(self)
                return

            default:
                break
            }
        }

        if augmentedSelectors.contains(selector) {
            super.doCommand(by: selector)
            self.nextResponder?.keyDown(with: keyDownEvent!)
            keyDownEvent = nil
            return
        }

        if skippedSelectors.contains(selector) {
            self.nextResponder?.keyDown(with: keyDownEvent!)
            keyDownEvent = nil
            return
        } else {
            super.doCommand(by: selector)
            keyDownEvent = nil
            return
        }
    }
}
