//
//  Constants.swift
//  CutBox
//
//  Created by Jason on 3/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Magnet

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
