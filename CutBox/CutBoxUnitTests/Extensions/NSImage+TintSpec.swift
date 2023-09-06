//
//  NSImage+TintSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 6/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class NSImageTintSpec: QuickSpec {
    override func spec() {
        describe("NSImage Tinting") {
            it("should tint the image with the specified color") {
                let image = self.createTestImage(
                    size: NSSize(width: 100, height: 100),
                    squareSize: NSSize(width: 80, height: 80))

                let tintedImage = image.tint(color: "#FF0000".color!)
                expect(tintedImage).notTo(beIdenticalTo(image))
                expect(tintedImage.isTemplate).to(beFalse())
                let pixelColor = self.samplePixelColor(from: tintedImage, at: NSPoint(x: 50, y: 50))
                expect(pixelColor?.toHex) == "FF0000" // Tints to a darker red
            }

            it("should return the original image if it's a template image") {
                let image = NSImage(size: NSSize(width: 100, height: 100))
                image.isTemplate = true
                let tintedImage = image.tint(color: .red)
                expect(tintedImage).to(beIdenticalTo(image))
            }
        }
    }

    func createTestImage(size: NSSize, squareSize: NSSize) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()

        NSColor.clear.set()
        NSBezierPath(rect: NSRect(origin: .zero, size: size)).fill()

        NSColor.white.set()
        let squareRect = NSRect(
            origin: NSPoint(x: (size.width - squareSize.width) / 2, y: (size.height - squareSize.height) / 2),
            size: squareSize
        )
        NSBezierPath(rect: squareRect).fill()

        image.unlockFocus()
        return image
    }

    func samplePixelColor(from image: NSImage, at point: NSPoint) -> NSColor? {
        if let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
            let bitmap = NSBitmapImageRep(cgImage: cgImage)
            let pixel = bitmap.colorAt(x: Int(point.x), y: Int(point.y))
            return pixel
        }
        return nil
    }
}
