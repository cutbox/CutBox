//
//  ClipItemTableRowImageButtonView.swift
//  CutBox
//
//  Created by Jason on 7/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class ClipItemTableRowImageButtonView: NSView {

    @IBOutlet weak var imageButton: NSButton!

    private var isFavorite: Bool {
        if let data = internalData {
            if let favoriteData = data["favorite"], !favoriteData.isEmpty {
                return true
            } else {
                return false
            }
        }
        return false
    }

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

    private func setup() {
        guard self.data != nil else {
            fatalError("Data must be initialized on ClipItemTableRowView before setup.")
        }

        self.imageButton.image = self.isFavorite ? #imageLiteral(resourceName: "star.png") : #imageLiteral(resourceName: "page.png")
        self.tintImage()
    }

    private func tintImage() {
        guard let imageData = self.imageButton.image else { fatalError("No image on clip") }
        let blended = imageData.tint(color: self.color)
        self.imageButton.image = blended
    }

}
