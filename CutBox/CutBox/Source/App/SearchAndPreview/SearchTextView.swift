//
//  SearchTextView.swift
//  CutBox
//
//  Created by Jason on 7/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

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

    override func doCommand(by selector: Selector) {
        if selector != NSSelectorFromString("noop:") {
            super.doCommand(by: selector)
        } else if  keyDownEvent != nil {
            self.nextResponder?.keyDown(with: keyDownEvent!)
        }
        keyDownEvent = nil
    }

}
