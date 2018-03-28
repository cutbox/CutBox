//
//  CutBoxPreferences.swift
//  CutBox
//
//  Created by Jason on 27/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class CutBoxPreferences {

    static let shared = CutBoxPreferences()

    var searchViewTextFieldFont = NSFont(
        name: "Helvetica Neue",
        size: 28)

    var searchViewClipItemsFont = NSFont(
        name: "Helvetica Neue",
        size: 16)

    var searchViewBackgroundColor = NSColor.lightGray

    var searchViewBackgroundAlpha = CGFloat(0.9)

    var searchViewTextFieldBackgroundColor = NSColor.textBackgroundColor

    var searchViewTextFieldCursorColor = NSColor.textColor

    var searchViewTextFieldTextColor = NSColor.textColor

    var searchViewPlaceholderTextColor = NSColor.lightGray

    var searchViewClipItemsTextColor = NSColor.textColor

    var searchViewClipItemsHighlightColor: NSColor?

    var searchFuzzyMatchMinScore = 0.1
}
