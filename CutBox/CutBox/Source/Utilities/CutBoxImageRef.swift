//
//  CutBoxImageRef.swift
//  CutBox
//
//  Created by jason on 13/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Cocoa

enum CutBoxImageRef: String {
    case magnitude
    case historyClockFaceWhite
    case star
    case page

    func image(_ dashed: Bool = false) -> NSImage {
        return get(self.rawValue, dashed: dashed)
    }

    private func get(_ named: String, dashed: Bool, withExtension: String = ".png") -> NSImage {
        var imageName = named
        if dashed {
            imageName = imageName.dashed
        }
        if let image = NSImage(named: "\(imageName)\(withExtension)") {
            return image
        } else {
            return NSImage.fake
        }
    }
}
