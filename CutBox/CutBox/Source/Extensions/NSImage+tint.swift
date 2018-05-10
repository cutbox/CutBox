//
//  NSImage+tint.swift
//  CutBox
//
//  Created by Jason on 10/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

extension NSImage {
    func tint(color: NSColor) -> NSImage {
        guard self.isTemplate == false else { return self }

        let image = self.copy() as! NSImage
        image.lockFocus()

        color.set()

        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()
        image.isTemplate = false

        return image
    }
}
