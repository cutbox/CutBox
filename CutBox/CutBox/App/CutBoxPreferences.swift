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

    var searchViewClipPreviewFont = NSFont(
        name: "Menlo",
        size: 14)

    var searchViewBackgroundColor = NSColor(
        calibratedRed: 0x24/0xff,
        green: 0x1C/0xff,
        blue: 0x1C/0xff,
        alpha: 1.0) // #241C1C

    var searchViewBackgroundAlpha = CGFloat(1.0)

    var searchViewTextFieldBackgroundColor = NSColor.textBackgroundColor

    var searchViewTextFieldCursorColor = NSColor.textColor

    var searchViewTextFieldTextColor = NSColor.textColor

    var searchViewPlaceholderTextColor = NSColor.lightGray

    var searchViewClipItemsTextColor = NSColor.white

    var searchViewClipItemsHighlightColor = NSColor.black

    var searchFuzzyMatchMinScore = 0.1

    var searchViewClipPreviewBackgroundColor = NSColor.black

    var searchViewClipPreviewTextColor = NSColor.white
}
