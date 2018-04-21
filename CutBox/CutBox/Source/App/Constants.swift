//
//  Constants.swift
//  CutBox
//
//  Created by Jason on 3/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Magnet

import Carbon.HIToolbox

struct Constants {
    static let kCutBoxToggleKeyCombo = "CutBoxToggleSearchPanelHotKey"

    static let searchFuzzyMatchMinScore = 0.1

    static let defaultCutBoxToggleKeyCombo =
        KeyCombo(keyCode: kVK_ANSI_V, cocoaModifiers: [.shift, .command])!
}
