//
//  CutBoxPreferences+TextScaling.swift
//  CutBox
//
//  Created by Jason Milkins on 24/9/22.
//  Copyright © 2018-2022 ocodo. All rights reserved.
//

import Foundation
import Cocoa

extension CutBoxPreferencesService {

    func scaleTextDown() {
        if let itemSize = self.searchViewClipTextFieldFont?.pointSize,
            let previewSize = self.searchViewClipPreviewFont?.pointSize {
            if itemSize > minItemSize {
                self.searchViewClipTextFieldFont = NSFont(name: "Helvetica Neue", size: itemSize - 1)
            }

            if previewSize > minPreviewSize {
                self.searchViewClipPreviewFont = NSFont(name: "Menlo", size: previewSize - 1)
            }
        } else {
            fatalError("ScaleTextDown get font size error")
        }
    }

    func scaleTextUp() {
        if let itemSize = self.searchViewClipTextFieldFont?.pointSize,
            let previewSize = self.searchViewClipPreviewFont?.pointSize {
            if itemSize < maxItemSize {
                self.searchViewClipTextFieldFont = NSFont(name: "Helvetica Neue", size: itemSize + 1.0)
            }

            if previewSize < maxPreviewSize {
                self.searchViewClipPreviewFont = NSFont(name: "Menlo", size: previewSize + 1.0)
            }
        } else {
            fatalError("ScaleTextUp get font size error")
        }
    }

    func scaleTextNormalize() {
        self.searchViewClipPreviewFont = NSFont(name: "Menlo", size: 12.0)
        self.searchViewClipTextFieldFont = NSFont(name: "Helvetica Neue", size: 12.0)
    }
}
