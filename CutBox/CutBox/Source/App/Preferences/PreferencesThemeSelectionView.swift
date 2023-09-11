//
//  PreferencesThemeSelectionView.swift
//  CutBox
//
//  Created by Jason MilkiCutBoxBase on 13/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class PreferencesThemeSelectionView: CutBoxBaseView {

    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var themeSelectorTitleLabel: CutBoxBaseTextField!
    @IBOutlet weak var themeSelectorMenu: CutBoxBasePopUpButton!
    @IBOutlet weak var compactUICheckbox: CutBoxBaseButton!
    @IBOutlet weak var hidePreviewCheckbox: CutBoxBaseButton!
    @IBOutlet weak var reloadThemesButton: CutBoxBaseButton!

    override func awakeFromNib() {
        prefs = CutBoxPreferencesService.shared

        self.setupThemeSelector()
        self.setupCompactUIControl()
        self.setupHidePreviewControl()
    }

    @IBAction func themeSelectorMenuChanges(_ sender: CutBoxBasePopUpButton) {
        prefs.theme = sender.index(of: sender.selectedItem!)
    }
}
