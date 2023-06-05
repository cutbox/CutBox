//
//  CutBoxColorTheme.swift
//  CutBox
//
//  Created by Jason Milkins on 12/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

typealias SearchTextTheme = (
    cursorColor: NSColor,
    textColor: NSColor,
    backgroundColor: NSColor,
    placeholderTextColor: NSColor
)

typealias ClipTheme = (
    backgroundColor: NSColor,
    textColor: NSColor,
    highlightColor: NSColor,
    highlightTextColor: NSColor
)

typealias PreviewTheme = (
    textColor: NSColor,
    backgroundColor: NSColor,
    selectedTextBackgroundColor: NSColor,
    selectedTextColor: NSColor
)

class CutBoxColorTheme {

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
}
