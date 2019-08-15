//
//  PreferencesThemePreview.swift
//  CutBox
//
//  Created by Jason on 22/5/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class PreferencesThemePreview: NSBox {

    @IBOutlet weak var topBar: NSBox!
    @IBOutlet weak var searchCutBox: NSTextField!
    @IBOutlet weak var footerBox: NSBox!
    @IBOutlet weak var itemsBox: NSBox!

    @IBOutlet weak var previewBox: NSBox!
    @IBOutlet weak var previewText: NSTextField!

    @IBOutlet weak var selectedItem: NSTextField!

    @IBOutlet weak var label1: NSTextField!
    @IBOutlet weak var label2: NSTextField!
    @IBOutlet weak var label3: NSTextField!
    @IBOutlet weak var label4: NSTextField!
    @IBOutlet weak var label5: NSTextField!
    @IBOutlet weak var label6: NSTextField!

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

        itemsBox.fillColor = theme.clip.clipItemsBackgroundColor
        selectedItem.backgroundColor = theme.clip.clipItemsHighlightColor
        selectedItem.textColor = theme.clip.clipItemsHighlightTextColor
        label1.textColor = theme.clip.clipItemsTextColor
        label2.textColor = theme.clip.clipItemsTextColor
        label3.textColor = theme.clip.clipItemsTextColor
        label4.textColor = theme.clip.clipItemsTextColor
        label5.textColor = theme.clip.clipItemsTextColor
        label6.textColor = theme.clip.clipItemsTextColor
    }

    override func awakeFromNib() {
        applyTheme()

        prefs.events.bind {
            switch $0 {
            case .themeChanged:
                self.applyTheme()

            default:
                break
            }
        }
        .disposed(by: disposeBag)
    }

}
