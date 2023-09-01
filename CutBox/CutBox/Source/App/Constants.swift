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

    static let cutBoxToggleKeyCombo = "CutBoxToggleSearchPanelHotKey"
    static let searchFuzzyMatchMinScore = 0.1
    static let defaultCutBoxToggleKeyCombo =
      KeyCombo(QWERTYKeyCode: kVK_ANSI_V, cocoaModifiers: [.shift, .command])!

    static let kHistoryStoreKey = "historyStore"
    static let kStringKey = "string"
    static let kFavoriteKey = "favorite"
    static let kTimestampKey = "timestamp"
}
