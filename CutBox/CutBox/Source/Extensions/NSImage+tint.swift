//
//  NSImage+tint.swift
//  CutBox
//
//  Created by Jason Milkins on 10/5/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa

extension NSImage {

    func tint(color: NSColor) -> NSImage {
        guard !self.isTemplate
            else { return self }

        guard let image = self.copy() as? NSImage
            else { return self }

        image.lockFocus()
        color.set()

        let imageRect = NSRect(origin: NSPoint.zero, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()
        image.isTemplate = false

        return image
    }
}
