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

    var internalColor: NSColor = NSColor.textColor
    var color: NSColor {
        set {
            internalColor = newValue
            self.title.textColor = internalColor
        }

        get {
            return internalColor
        }
    }

    var internalData: [String: Any]?
    var data: [String: Any]? {
        get {
            return internalData
        }
        set {
            internalData = newValue
            setup()
        }
    }

    func setup() {
    }

}
