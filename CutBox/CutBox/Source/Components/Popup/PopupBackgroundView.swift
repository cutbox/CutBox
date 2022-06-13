//
//  PopupBackgroundView.swift
//  CutBox
//
//  Created by Jason Milkins on 24/3/18.
//  Copyright © 2018-2022 ocodo. All rights reserved.
//

import Cocoa

public class PopupBackgroundView: NSView {
    public var cornerRadius: CGFloat = 0
    public var backgroundColor = NSColor.clear

    public override func draw(_ dirtyRect: NSRect) {
        let contentRect = self.bounds
        let path = NSBezierPath()
        path.appendRoundedRect(contentRect, xRadius: cornerRadius, yRadius: cornerRadius)
        path.close()
        backgroundColor.setFill()
        path.fill()
    }
}
