//
//  ClipItemTableRowImageView.swift
//  CutBox
//
//  Created by Jason on 7/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class ClipItemTableRowImageView: ItemTableRowImageView {
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

    override func setup() {
        guard self.data != nil else {
            fatalError("Data must be initialized on ClipItemTableRowView before setup.")
        }

        self.image.image = self.isFavorite ? #imageLiteral(resourceName: "star.png") : #imageLiteral(resourceName: "page.png")
        self.tintImage()
    }
}


