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
        let (key, modifiers) = (event.keyCode, event.modifierFlags)
        debugPrint(key, modifiers)
        super.keyDown(with: event)
    }
}
