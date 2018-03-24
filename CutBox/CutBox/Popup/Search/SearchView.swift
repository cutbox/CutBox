//
//  SearchView.swift
//  CutBox
//
//  Created by Jason on 24/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class SearchView: NSView {

    override init(frame: NSRect) {
        super.init(frame: frame)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override var acceptsFirstResponder: Bool {
        return true
    }

    override func keyDown(with event: NSEvent) {
        let (keyCode, modifier) = (
            KeyCode(rawValue: event.keyCode),
            event.modifierFlags.getModifierKey()
        )
        guard let key = keyCode else { return }

        switch (key, modifier) {
        case (.slash, .shift?):
            debugPrint("question mark")
        case (.slash, nil):
            debugPrint("slash")
        case (.up, nil):
            debugPrint("up")
        case (.down, nil):
            debugPrint("down")
        case (.left, nil):
            debugPrint("left")
        case (.right, nil):
            debugPrint("right")
        default:
            debugPrint(event.keyCode, modifier as Any)
            super.keyDown(with: event)
        }
    }
}
