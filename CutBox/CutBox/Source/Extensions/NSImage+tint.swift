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

        //swiftlint:disable force_cast
        let image = self.copy() as! NSImage
        //swiftlint:enable force_cast

        image.lockFocus()
        color.set()

        let imageRect = NSRect(origin: NSPoint.zero, size: image.size)
        imageRect.fill(using: .sourceAtop)

        image.unlockFocus()
        image.isTemplate = false

        return image
    }
}
