//
//  PopupBackgroundView.swift
//  CutBox
//
//  Created by Jason on 24/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

public class PopupBackgroundView: NSView {
    public var cornerRadius: CGFloat = 6
    public var backgroundColor = NSColor.windowBackgroundColor

    public override func draw(_ dirtyRect: NSRect) {
        let contentRect = self.bounds
        let path = NSBezierPath()
        path.appendRoundedRect(contentRect, xRadius: cornerRadius, yRadius: cornerRadius)
        path.close()
        backgroundColor.setFill()
        path.fill()
    }
}
