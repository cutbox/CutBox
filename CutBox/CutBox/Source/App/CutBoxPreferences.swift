//
//  CutBoxPreferences.swift
//  CutBox
//
//  Created by Jason on 27/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import Magnet

struct VersionService  {
    static var version: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"],
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] {
            return "version: \(version) (\(buildNumber))"
        }
        return "ERROR: Cannot get version"
    }
}

struct Constants {
    static let searchKeyComboUserDefaults = "CutBoxToggleSearchPanelHotKey"
    static let cutBoxProductHomeUrl = "https://github.com/ocodo/CutBox"
    static let cutBoxProductTitle = "CutBox"
    static let cutBoxCopyrightLicense = "Copyright © 2018 Jason Milkins\nLicensed under GNU GPL3"
    static let searchViewPlaceholderText = "Search CutBox History"
    static let searchFuzzyMatchMinScore = 0.1
    static let defaultSearchCustomKeyCombo = KeyCombo(keyCode: 9,
                                                      cocoaModifiers: [.shift, .command])!
}

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

    var searchViewBackgroundAlpha = CGFloat(1.0)

    var searchViewBackgroundColor            = #colorLiteral(red: 0.1296178, green: 0.2685749845, blue: 0.3490234375, alpha: 1)

    var searchViewTextFieldCursorColor       = #colorLiteral(red: 0.05882352941, green: 0.1098039216, blue: 0.1294117647, alpha: 1)

    var searchViewTextFieldTextColor         = #colorLiteral(red: 0.0585, green: 0.10855, blue: 0.13, alpha: 1)

    var searchViewTextFieldBackgroundColor   = #colorLiteral(red: 0.9280523557, green: 0.9549868208, blue: 0.9678013393, alpha: 1)

    var searchViewPlaceholderTextColor       = #colorLiteral(red: 0.6817694399, green: 0.7659880177, blue: 0.802081694, alpha: 1)

    var searchViewClipItemsTextColor         = #colorLiteral(red: 0.6781874895, green: 0.7567896247, blue: 0.7959117293, alpha: 1)

    var searchViewClipItemsHighlightColor    = #colorLiteral(red: 0.0135, green: 0.02505, blue: 0.03, alpha: 1)

    var searchViewClipPreviewTextColor       = #colorLiteral(red: 0.6820933223, green: 0.7646310925, blue: 0.803753078, alpha: 1)

    var searchViewClipPreviewBackgroundColor = #colorLiteral(red: 0.02545906228, green: 0.02863771868, blue: 0.03, alpha: 1)
}



