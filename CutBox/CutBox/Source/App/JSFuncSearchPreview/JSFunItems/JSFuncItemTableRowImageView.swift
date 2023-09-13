//
//  JSFuncItemTableRowImageView.swift
//  CutBox
//
//  Created by Jason Milkins on 17/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

class JSFuncItemTableRowImageView: ItemTableRowImageView {

    override func setup() {
        self.image.image = CutBoxImageRef.page.image()
        self.tintImage()
    }
}
