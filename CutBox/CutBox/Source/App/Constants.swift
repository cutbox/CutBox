//
//  Constants.swift
//  CutBox
//
//  Created by Jason Milkins on 3/4/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Magnet

import Carbon.HIToolbox

struct Constants {

    static let cutBoxToggleKeyCombo = "CutBoxToggleSearchPanelHotKey"

    static let searchFuzzyMatchMinScore = 0.1

    static let defaultCutBoxToggleKeyCombo =
      KeyCombo(QWERTYKeyCode: kVK_ANSI_V, cocoaModifiers: [.shift, .command])!

}
