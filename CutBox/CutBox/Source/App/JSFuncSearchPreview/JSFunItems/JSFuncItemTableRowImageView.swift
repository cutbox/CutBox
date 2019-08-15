//
//  JSFuncItemTableRowImageView.swift
//  CutBox
//
//  Created by Jason on 17/5/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Cocoa

class JSFuncItemTableRowImageView: ItemTableRowImageView {

    override func setup() {
        self.image.image = #imageLiteral(resourceName: "page.png")
        self.tintImage()
    }

}
