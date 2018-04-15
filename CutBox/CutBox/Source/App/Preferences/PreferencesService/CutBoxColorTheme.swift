//
//  CutBoxColorTheme.swift
//  CutBox
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

struct CutBoxColorTheme {
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
}
