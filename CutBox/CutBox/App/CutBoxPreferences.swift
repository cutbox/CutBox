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
        size: 20)

    var searchViewBackgroundColor = NSColor.darkGray

    var searchViewBackgroundAlpha = CGFloat(1.0)

    var searchViewTextFieldBackgroundColor = NSColor.textBackgroundColor

    var searchViewTextFieldCursorColor = NSColor.textColor

    var searchViewTextFieldTextColor = NSColor.textColor

    var searchViewPlaceholderTextColor = NSColor.lightGray

    var searchViewClipItemsTextColor = NSColor.white

    var searchViewClipItemsHighlightColor: NSColor?

    var searchFuzzyMatchMinScore = 0.1
}
