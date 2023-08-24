//
//  ItemTableRowImageView.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

class ItemTableRowImageView: NSView {

    @IBOutlet weak var image: NSImageView!

    var internalColor: NSColor = .textColor {
        didSet {
            tintImage()
        }
    }

    var color: NSColor {
        get {
            return internalColor
        }

        set {
            internalColor = newValue
        }
    }

    var internalData: [String: String]? {
        didSet {
            setup()
        }
    }

    var data: [String: String]? {
        get {
            return internalData
        }

        set {
            internalData = newValue
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
