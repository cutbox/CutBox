//
//  ClipItemTableRowImageButtonView.swift
//  CutBox
//
//  Created by Jason Milkins on 7/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

class ClipItemTableRowImageButtonView: NSView {

    @IBOutlet weak var imageButton: NSButton!

    private var isFavorite: Bool {
        if let data = data,
           let favoriteData = data["favorite"],
            !favoriteData.isEmpty {
            return true
        }
        return false
    }

    private var internalColor: NSColor = NSColor.textColor
    var color: NSColor {
        get {
            return internalColor
        }

        set {
            internalColor = newValue
            self.tintImage()
        }
    }

    private var internalData: [String: String]?
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

        self.imageButton.image = self.isFavorite
        ? CutBoxImageRef.star.image()
        : CutBoxImageRef.page.image()

        self.tintImage()
    }

    private func tintImage() {
        guard let imageData = self.imageButton.image else { return }
        let blended = imageData.tint(color: self.color)
        self.imageButton.image = blended
    }
}
