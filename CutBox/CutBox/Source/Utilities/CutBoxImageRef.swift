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
    case statusIcon

    func image(_ dashed: Bool = false, with withExtension: String = ".png" ) -> NSImage {
        return get(self.rawValue, dashed: dashed, withExtension: withExtension)
    }

    private func get(_ named: String, dashed: Bool, withExtension: String) -> NSImage {
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
