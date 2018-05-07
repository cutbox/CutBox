//
//  ClipItemTableRowView.swift
//  CutBox
//
//  Created by Jason on 7/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa


class ClipItemTableRowView: NSView {

    var _color: NSColor = NSColor.textColor
    var color: NSColor {
        set {
            _color = newValue
            self.tintImage()
            self.title.textColor = _color
        }

        get {
            return _color
        }
    }

    @IBOutlet weak var title: NSTextField!
    @IBOutlet weak var image: NSImageView!

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
        self.image.image = self.isFavorite ? #imageLiteral(resourceName: "star.png") : #imageLiteral(resourceName: "text-document.png")
        self.tintImage()
    }

    private func tintImage() {
        guard let imageData = self.image.image else { fatalError("No image on clip") }
        let blended = imageData.tint(color: self.color)
        self.image.image = blended
    }
}
