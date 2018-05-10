//
//  ClipItemTableRowImageView.swift
//  CutBox
//
//  Created by Jason on 7/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class ClipItemTableRowImageView: NSView {

    @IBOutlet weak var image: NSImageView!

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

    var _color: NSColor = NSColor.textColor
    var color: NSColor {
        set {
            _color = newValue
            self.tintImage()
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

    private func setup() {
        guard self.data != nil else {
            fatalError("Data must be initialized on ClipItemTableRowView before setup.")
        }

        self.image.image = self.isFavorite ? #imageLiteral(resourceName: "star.png") : #imageLiteral(resourceName: "page.png")
        self.tintImage()
    }

    private func tintImage() {
        guard let imageData = self.image.image else { fatalError("No image on clip") }
        let blended = imageData.tint(color: self.color)
        self.image.image = blended
    }
}


