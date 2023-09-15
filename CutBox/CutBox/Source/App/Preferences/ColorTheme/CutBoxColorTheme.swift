//
//  CutBoxColorTheme.swift
//  CutBox
//
//  Created by Jason Milkins on 12/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

struct SearchTextTheme: Equatable {
    var cursorColor: NSColor
    var textColor: NSColor
    var backgroundColor: NSColor
    var placeholderTextColor: NSColor
}

struct ClipTheme: Equatable {
    var backgroundColor: NSColor
    var textColor: NSColor
    var highlightColor: NSColor
    var highlightTextColor: NSColor
}

struct PreviewTheme: Equatable {
    var textColor: NSColor
    var backgroundColor: NSColor
    var selectedTextBackgroundColor: NSColor
    var selectedTextColor: NSColor
}

class CutBoxColorTheme: Equatable, CustomStringConvertible {
    static func == (lhs: CutBoxColorTheme, rhs: CutBoxColorTheme) -> Bool {
        lhs.name == rhs.name &&
        lhs.spacing == rhs.spacing &&
        lhs.popupBackgroundColor == rhs.popupBackgroundColor &&
        lhs.searchText == rhs.searchText &&
        lhs.clip == rhs.clip &&
        lhs.preview == rhs.preview
    }

    let name: String
    var spacing: CGFloat
    let popupBackgroundColor: NSColor
    let searchText: SearchTextTheme
    let clip: ClipTheme
    let preview: PreviewTheme

    init(name: String,
         popupBackgroundColor: NSColor,
         searchText: SearchTextTheme,
         clip: ClipTheme,
         preview: PreviewTheme,
         spacing: CGFloat = 5) {

        self.name = name
        self.spacing = spacing
        self.popupBackgroundColor = popupBackgroundColor
        self.searchText = searchText
        self.clip = clip
        self.preview = preview
    }

    var description: String {
        """
        {
            "name": "\(name)",
            "popupBackgroundColor": "\(popupBackgroundColor)",
            "searchText": {
            "cursorColor": "\(searchText.cursorColor)",
                    "textColor": "\(searchText.textColor)",
                    "backgroundColor": "\(searchText.backgroundColor)",
                    "placeholderTextColor": "\(searchText.placeholderTextColor)"
                },
                "clip": {
                    "backgroundColor": "\(clip.backgroundColor)",
                    "textColor": "\(clip.textColor)",
                    "highlightColor": "\(clip.highlightColor)",
                    "highlightTextColor": "\(clip.highlightTextColor)"
                },
                "preview": {
                    "textColor": "\(preview.textColor)",
                    "backgroundColor": "\(preview.backgroundColor)",
                    "selectedTextBackgroundColor": "\(preview.selectedTextBackgroundColor)",
                    "selectedTextColor": "\(preview.selectedTextColor)"
                },
            "spacing": \(spacing),
        }
        """
    }
}
