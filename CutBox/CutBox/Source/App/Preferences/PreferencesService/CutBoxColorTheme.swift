//
//  CutBoxColorTheme.swift
//  CutBox
//
//  Created by Jason Milkins on 12/4/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa

class CutBoxColorTheme {

    let name: String

    var spacing: CGFloat

    let popupBackgroundColor: NSColor

    let searchText: (cursorColor: NSColor,
    textColor: NSColor,
    backgroundColor: NSColor,
    placeholderTextColor: NSColor)

    let clip: (clipItemsBackgroundColor: NSColor,
    clipItemsTextColor: NSColor,
    clipItemsHighlightColor: NSColor,
    clipItemsHighlightTextColor: NSColor)

    let preview: (textColor: NSColor,
    backgroundColor: NSColor,
    selectedTextBackgroundColor: NSColor)

    typealias SearchTextTheme = (
        cursorColor: NSColor,
        textColor: NSColor,
        backgroundColor: NSColor,
        placeholderTextColor: NSColor
    )

    typealias ClipTheme = (
        clipItemsBackgroundColor: NSColor,
        clipItemsTextColor: NSColor,
        clipItemsHighlightColor: NSColor,
        clipItemsHighlightTextColor: NSColor
    )

    typealias PreviewTheme = (
        textColor: NSColor,
        backgroundColor: NSColor,
        selectedTextBackgroundColor: NSColor
    )

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
