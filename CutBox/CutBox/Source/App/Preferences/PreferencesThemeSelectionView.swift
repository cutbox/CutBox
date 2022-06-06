//
//  PreferencesThemeSelectionView.swift
//  CutBox
//
//  Created by Jason Milkins on 13/5/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class PreferencesThemeSelectionView: NSView {

    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var themeSelectorTitleLabel: NSTextField!
    @IBOutlet weak var themeSelectorMenu: NSPopUpButton!
    @IBOutlet weak var compactUICheckbox: NSButton!
    @IBOutlet weak var reloadThemesButton: NSButton!

    override func awakeFromNib() {
        prefs = CutBoxPreferencesService.shared

        self.setupThemeSelector()
        self.setupCompactUIControl()
    }

    @IBAction func themeSelectorMenuChanges(_ sender: NSPopUpButton) {
        prefs.theme = sender.index(of: sender.selectedItem!)
    }
}
