//
//  PreferencesThemeSelectionView.swift
//  CutBox
//
//  Created by Jason on 13/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import RxSwift

class PreferencesThemeSelectionView: NSView {

    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var themeSelectorTitleLabel: NSTextField!
    @IBOutlet weak var themeSelectorMenu: NSPopUpButton!
    @IBOutlet weak var compactUICheckbox: NSButton!

    override func awakeFromNib() {
        prefs = CutBoxPreferencesService.shared

        self.setupThemeSelector()
        self.setupCompactUIControl()
    }

    @IBAction func themeSelectorMenuChanges(_ sender: NSPopUpButton) {
        prefs.theme = sender.index(of: sender.selectedItem!)
    }

}
