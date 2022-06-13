//
//  ItemTableRowTextView.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2022 ocodo. All rights reserved.
//

import Cocoa

class ItemTableRowTextView: NSView {

    @IBOutlet weak var title: NSTextField!

    var internalColor: NSColor = NSColor.textColor
    var color: NSColor {
        get {
            return internalColor
        }

        set {
            internalColor = newValue
            self.title.textColor = internalColor
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
