//
//  Constants.swift
//  CutBox
//
//  Created by Jason on 3/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Magnet

struct Constants {
    static let kCutBoxToggleKeyCombo = "CutBoxToggleSearchPanelHotKey"

    static let homeUrl = "https://github.com/ocodo/CutBox"
    static let productTitle = "CutBox"
    static let copyrightLicense = "Copyright © 2018 Jason Milkins\nLicensed under GNU GPL3"
    static let searchViewPlaceholderText = "Search CutBox History"

    static let searchFuzzyMatchMinScore = 0.1

    static let defaultCutBoxToggleKeyCombo =
        KeyCombo(keyCode: 9,
                 cocoaModifiers: [.shift, .command])!

    static let defaultSearchModeToggleKeyCombo =
        KeyCombo(keyCode: 8,
                 cocoaModifiers: [.shift, .command])!
}
