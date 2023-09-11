//
//  PreferencesThemePreview.swift
//  CutBox
//
//  Created by Jason Milkins on 22/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class PreferencesThemePreview: CutBoxBaseBox {

    @IBOutlet weak var topBar: CutBoxBaseBox!
    @IBOutlet weak var searchCutBox: CutBoxBaseTextField!
    @IBOutlet weak var footerBox: CutBoxBaseBox!
    @IBOutlet weak var itemsBox: CutBoxBaseBox!

    @IBOutlet weak var previewBox: CutBoxBaseBox!
    @IBOutlet weak var previewText: CutBoxBaseTextField!

    @IBOutlet weak var selectedItem: CutBoxBaseTextField!

    @IBOutlet weak var label1: CutBoxBaseTextField!
    @IBOutlet weak var label2: CutBoxBaseTextField!
    @IBOutlet weak var label3: CutBoxBaseTextField!
    @IBOutlet weak var label4: CutBoxBaseTextField!
    @IBOutlet weak var label5: CutBoxBaseTextField!
    @IBOutlet weak var label6: CutBoxBaseTextField!

    let prefs = CutBoxPreferencesService.shared

    let disposeBag = DisposeBag()

    func applyTheme() {
        let theme = prefs.currentTheme

        fillColor = theme.popupBackgroundColor
        searchCutBox.textColor = theme.searchText.textColor
        topBar.fillColor = theme.searchText.backgroundColor
        footerBox.fillColor = theme.popupBackgroundColor

        previewBox.fillColor = theme.preview.backgroundColor
        previewText.textColor = theme.preview.textColor

        itemsBox.fillColor = theme.clip.backgroundColor
        selectedItem.backgroundColor = theme.clip.highlightColor
        selectedItem.textColor = theme.clip.highlightTextColor
        label1.textColor = theme.clip.textColor
        label2.textColor = theme.clip.textColor
        label3.textColor = theme.clip.textColor
        label4.textColor = theme.clip.textColor
        label5.textColor = theme.clip.textColor
        label6.textColor = theme.clip.textColor
    }

    override func awakeFromNib() {
        applyTheme()

        prefs.events.bind {
            switch $0 {
            case .themeChanged:
                self.applyTheme()

            case .themesReloaded:
                self.applyTheme()

            default:
                break
            }
        }.disposed(by: disposeBag)
    }
}
