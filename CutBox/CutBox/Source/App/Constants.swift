//
//  Constants.swift
//  CutBox
//
//  Created by Jason Milkins on 3/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Magnet

import Carbon.HIToolbox

enum Constants {
    static let cutBoxUserThemesLocation = "~/.config/cutbox"
    static let cutBoxJSLocation = "~/.cutbox.js"

    static let cutBoxToggleKeyCombo = "CutBoxToggleSearchPanelHotKey"
    static let searchFuzzyMatchMinScore = 0.1
    static let defaultCutBoxToggleKeyCombo =
      KeyCombo(QWERTYKeyCode: kVK_ANSI_V, cocoaModifiers: [.shift, .command])!

    static let kHistoryStoreKey = "historyStore"
    static let kStringKey = "string"
    static let kFavoriteKey = "favorite"
    static let kTimestampKey = "timestamp"

    static let kMultiJoinSeparator = "multiJoinSeparator"
    static let kUseJoinSeparator = "useJoinSeparator"
    static let kUseWrappingStrings = "useWrappingStrings"
    static let kWrapStringStart = "wrapStringStart"
    static let kWrapStringEnd = "wrapStringEnd"
    static let kHistoryLimited = "historyLimited"
    static let kHistoryLimit = "historyLimit"
    static let kUseCompactUI = "useCompactUI"
    static let kHidePreview = "hidePreview"
    static let kProtectFavorites = "protectFavorites"
    static let kSavedTimeFilterValue = "savedTimeFilterValue"
}
