//
//  PreferencesGeneralView.swift
//  CutBox
//
//  Created by Jason Milkins on 13/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa
import RxSwift
import Magnet
import KeyHolder

class PreferencesGeneralView: NSView {
    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    var hotKeyService: HotKeyService!
    var hotKeyCenter: HotKeyCenter!
    var loginItemsService: LoginItemsService!

    @IBOutlet weak var mainKeyRecorder: RecordView!
    @IBOutlet weak var mainKeyRecorderLabel: NSTextField!
    @IBOutlet weak var autoLoginCheckbox: NSButton!
    @IBOutlet weak var protectFavoritesCheckbox: NSButton!
    @IBOutlet weak var showAllHiddenDialogBoxesButton: NSButton!

    override func awakeFromNib() {
        self.loginItemsService = LoginItemsService.shared
        self.hotKeyService = HotKeyService.shared
        self.hotKeyCenter = HotKeyCenter.shared
        self.prefs = CutBoxPreferencesService.shared

        setupKeyRecorders()
        setupProtectFavoritesCheckbox()
        setupAutoLoginControl()
        setupShowAllHiddenDialogBoxesButton()
    }
}
