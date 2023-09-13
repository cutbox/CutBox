//
//  NSImage+fake.swift
//  CutBox
//
//  Created by jason on 13/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Cocoa

extension NSImage {
    static var fake: NSImage {
        return createFakeImage(size: NSSize(width: 100, height: 100), color: .blue)
    }

    static func fake(size: NSSize = NSSize(width: 100, height: 100), color: NSColor = .blue) -> NSImage {
        return createFakeImage(size: size, color: color)
    }

    private static func createFakeImage(size: NSSize, color: NSColor) -> NSImage {
        let placeholderImage = NSImage(size: size)

        placeholderImage.lockFocus()
        color.set()
        NSBezierPath(
            rect: NSRect(x: 0, y: 0,
                         width: size.width,
                         height: size.height)).fill()
        placeholderImage.unlockFocus()

       return placeholderImage
    }
}
