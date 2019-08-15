//
//  ItemTableRowImageView.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Cocoa

class ItemTableRowImageView: NSView {

    @IBOutlet weak var image: NSImageView!

    var internalColor: NSColor = NSColor.textColor
    var color: NSColor {
        set {
            internalColor = newValue
            self.tintImage()
        }

        get {
            return internalColor
        }
    }

    var internalData: [String: String]?
    var data: [String: String]? {
        get {
            return internalData
        }
        set {
            internalData = newValue
            setup()
        }
    }

    func setup() {
        fatalError("no default setup")
    }

    func tintImage() {
        guard let imageData = self.image.image else { fatalError("No image on clip") }
        let blended = imageData.tint(color: self.color)
        self.image.image = blended
    }

}
