//
//  ClipItemTableRowTextView.swift
//  CutBox
//
//  Created by Jason on 7/5/18.
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

class JSFuncItemTableRowTextView: ItemTableRowTextView {
    override func setup() {
        guard let data = self.data else {
            fatalError("Data must be initialized on ClipItemTableRowView before setup.")
        }

        guard let titleString = data["string"] as? String else {
            fatalError("Data must contain key: string")
        }

        self.title.stringValue = titleString
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

class ClipItemTableRowTextView: ItemTableRowTextView {
    private var isFavorite: Bool {
        if let data = _data {
            if let favoriteData = data["favorite"] as? String, !favoriteData.isEmpty {
                return true
            } else {
                return false
            }
        }
        return false
    }

    override func setup() {
        guard let data = self.data else {
            fatalError("Data must be initialized on ClipItemTableRowView before setup.")
        }

        guard let titleString = data["string"] as? String else {
            fatalError("Data must contain key: string")
        }

        self.title.stringValue = titleString
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
