//
//  SearchViewTextFieldCell.swift
//  CutBox
//
//  Created by Jason on 7/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class SearchViewTextFieldCell: NSTextFieldCell {

    override func drawingRect(forBounds rect: NSRect) -> NSRect {
        var newRect = super.drawingRect(forBounds: rect)
        newRect.origin.y += 7
        newRect.origin.x += 7

        return newRect
    }
}
