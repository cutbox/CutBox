//
//  CutBoxColorTheme.swift
//  CutBox
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class CutBoxColorTheme {

    static var instances: [CutBoxColorTheme] = []

    let name: String

    let popupBackgroundColor: NSColor

    let searchText: (cursorColor: NSColor,
    textColor: NSColor,
    backgroundColor: NSColor,
    placeholderTextColor: NSColor)

    let clip: (clipItemsBackgroundColor: NSColor,
    clipItemsTextColor: NSColor,
    clipItemsHighlightColor: NSColor)

    let preview: (textColor: NSColor,
    backgroundColor: NSColor,
    selectedTextBackgroundColor: NSColor)

    private let index: Int

    init(name: String,
         popupBackgroundColor: NSColor,
         searchText: (cursorColor: NSColor, textColor: NSColor, backgroundColor: NSColor, placeholderTextColor: NSColor),
         clip: (clipItemsBackgroundColor: NSColor, clipItemsTextColor: NSColor, clipItemsHighlightColor: NSColor),
         preview: (textColor: NSColor, backgroundColor: NSColor, selectedTextBackgroundColor: NSColor)) {

        self.name = name
        self.popupBackgroundColor = popupBackgroundColor
        self.searchText = searchText
        self.clip = clip
        self.preview = preview
        self.index = CutBoxColorTheme.instances.count

        CutBoxColorTheme.instances.append(self)
    }

    deinit {
        CutBoxColorTheme.instances.remove(at: self.index)
    }
}
