//
//  ClipItemTableRowTextView.swift
//  CutBox
//
//  Created by Jason on 7/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class ClipItemTableRowTextView: NSView {

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

    var _data: [String:String]?
    var data: [String:String]? {
        get {
            return _data
        }
        set {
            _data = newValue
            setup()
        }
    }

    private var isFavorite: Bool {
        if let data = _data {
            if let favoriteData = data["favorite"], !favoriteData.isEmpty {
                return true
            } else {
                return false
            }
        }
        return false
    }

    private func setup() {
        guard let data = self.data else {
            fatalError("Data must be initialized on ClipItemTableRowView before setup.")
        }

        guard let titleString = data["string"] else {
            fatalError("Data must contain key: string")
        }

        self.title.stringValue = titleString.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
