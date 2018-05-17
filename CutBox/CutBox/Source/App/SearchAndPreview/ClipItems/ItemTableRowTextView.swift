//
//  ItemTableRowTextView.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class ItemTableRowTextView: NSView {
    @IBOutlet weak var title: NSTextField!

    var _color: NSColor = NSColor.textColor
    var color: NSColor {
        set {
            _color = newValue
            self.title.textColor = _color
        }

        get {
            return _color
        }
    }

    var _data: [String:Any]?
    var data: [String:Any]? {
        get {
            return _data
        }
        set {
            _data = newValue
            setup()
        }
    }

    func setup() {
    }
}
