//
//  ClipItemTableRowImageView.swift
//  CutBox
//
//  Created by Jason Milkins on 7/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

class ClipItemTableRowImageView: ItemTableRowImageView {

    private var isFavorite: Bool {
        return internalData?["favorite"] != nil
    }

    override func setup() {
        guard self.data != nil else {
            fatalError("Data must be initialized on ClipItemTableRowImageView before setup.")
        }

        self.image.image = self.isFavorite
            ? #imageLiteral(resourceName: "star.png")
            : #imageLiteral(resourceName: "page.png")

        self.tintImage()
    }
}
