//
//  CutBoxPreferences.swift
//  CutBox
//
//  Created by Jason on 27/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Magnet
import RxSwift

class CutBoxEnvironment {
    var mainController: CutBoxController?

    func setup(mainController: CutBoxController) {
        self.mainController = mainController
    }
}

class CutBoxPreferences {

    static let shared = CutBoxPreferences()

    let disposeBag = DisposeBag()
    let environment = CutBoxEnvironment()

    var searchCustomKeyCombo = PublishSubject<KeyCombo>()

    init() {
        self.searchCustomKeyCombo
            .distinctUntilChanged {
                $0.keyCode == $1.keyCode
                    && $0.modifiers == $1.modifiers
            }
            .subscribe(onNext: { self.changeGlobalToggle(keyCombo: $0) })
            .disposed(by: disposeBag)
    }

    let searchKeyComboUserDefaults = "CutBoxToggleSearchPanelHotKey"

    let globalDefaultKeyCombo = KeyCombo(keyCode: 9, cocoaModifiers: [.shift, .command])

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

    var searchViewBackgroundColor            = #colorLiteral(red: 0.07675106282, green: 0.1590322896, blue: 0.2066685268, alpha: 1)

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

}

extension CutBoxPreferences {
    var cutBoxVersionString: String {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"],
            let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] {
            return "version: \(version) (\(buildNumber))"
        }
        return "ERROR: Cannot get version"
    }
}

extension CutBoxPreferences {

    func resetDefaultGlobalToggle() {
        if let savedKeyCombo = KeyCombo.loadFromUserDefaults(identifier: searchKeyComboUserDefaults) {
            self.searchCustomKeyCombo.onNext(savedKeyCombo)
        } else {
            self.searchCustomKeyCombo.onNext(globalDefaultKeyCombo!)
        }
    }

    fileprivate func changeGlobalToggle(keyCombo: KeyCombo) {
        guard let controller = environment.mainController else {
            fatalError("CutBoxEnvironment needs mainController configured (CutBoxController)")
        }

        let hotKey = HotKey(
            identifier: self.searchKeyComboUserDefaults,
            keyCombo: keyCombo,
            target: controller,
            action: #selector(controller.searchClicked(_:))
        )

        hotKey.register()

        keyCombo.saveToUserDefaults(identifier: self.searchKeyComboUserDefaults)
    }
}

