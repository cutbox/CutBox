//
//  CutBoxPreferences.swift
//  CutBox
//
//  Created by Jason on 27/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Magnet

class CutBoxEnvironment {
    var mainController: CutBoxController?

    func setup(mainController: CutBoxController) {
        self.mainController = mainController
    }
}

class CutBoxPreferences {

    static let shared = CutBoxPreferences()

    var cutBoxVersionString: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"],
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] {
            return "version: \(version) (\(buildNumber))"
        }
        return "ERROR: Cannot get version"
    }

    let searchUserDefaultKey = "kCutBoxHotKeySearchKeyCombo"
    var searchCustomKeyCombo: KeyCombo?

    let environment = CutBoxEnvironment()

    var globalKeyCombo: KeyCombo = KeyCombo(
        keyCode: 9,
        cocoaModifiers: [.command, .shift])!

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

    var searchViewBackgroundColor            = #colorLiteral(red: 0.0585, green: 0.10855, blue: 0.13, alpha: 1)

    var searchViewTextFieldCursorColor       = #colorLiteral(red: 0.05882352941, green: 0.1098039216, blue: 0.1294117647, alpha: 1)

    var searchViewTextFieldTextColor         = #colorLiteral(red: 0.0585, green: 0.10855, blue: 0.13, alpha: 1)

    var searchViewTextFieldBackgroundColor   = #colorLiteral(red: 0.9280523557, green: 0.9549868208, blue: 0.9678013393, alpha: 1)

    var searchViewPlaceholderTextColor       = #colorLiteral(red: 0.6817694399, green: 0.7659880177, blue: 0.802081694, alpha: 1)

    var searchViewClipItemsTextColor         = #colorLiteral(red: 0.6781874895, green: 0.7567896247, blue: 0.7959117293, alpha: 1)

    var searchViewClipItemsHighlightColor    = #colorLiteral(red: 0.0135, green: 0.02505, blue: 0.03, alpha: 1)

    var searchViewClipPreviewTextColor       = #colorLiteral(red: 0.6820933223, green: 0.7646310925, blue: 0.803753078, alpha: 1)

    var searchViewClipPreviewBackgroundColor = #colorLiteral(red: 0.02545906228, green: 0.02863771868, blue: 0.03, alpha: 1)

    let cutBoxProductTitle = "CutBox"

    let cutBoxProductHomeUrl = "https://github.com/ocodo/CutBox"

    let cutBoxCopyrightLicense = "Copyright © 2018 Jason Milkins\nLicensed under GNU GPL3"

    var searchViewPlaceholderText = "Search CutBox History"
    var searchFuzzyMatchMinScore = 0.1

    var url = "https://github.com/ocodo/CutBox"

    func resetDefaultGlobalToggle() {
        changeGlobalToggle(keyCombo: globalKeyCombo)
    }

    func changeGlobalToggle(keyCombo: KeyCombo) {
        guard let controller = environment.mainController else {
            fatalError("CutBoxEnvironment needs mainController configured (CutBoxController)")
        }

        let hotKey = HotKey(
            identifier: "CutBoxToggleSearchPanel",
            keyCombo: keyCombo,
            target: controller,
            action: #selector(controller.searchClicked(_:))
        )

        self.searchCustomKeyCombo = keyCombo
        hotKey.register()
    }
}
