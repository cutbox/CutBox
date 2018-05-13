//
//  PreferencesGeneralView.swift
//  CutBox
//
//  Created by Jason on 13/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
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

    @IBOutlet weak var mainKeyRecorder: RecordView!
    @IBOutlet weak var mainKeyRecorderLabel: NSTextField!

    var loginItemsService: LoginItemsService!

    @IBOutlet weak var autoLoginCheckbox: NSButton!

    @IBOutlet weak var protectFavoritesCheckbox: NSButton!

    override func awakeFromNib() {
        self.loginItemsService = LoginItemsService.shared
        self.hotKeyService = HotKeyService.shared
        self.hotKeyCenter = HotKeyCenter.shared
        self.prefs = CutBoxPreferencesService.shared

        setupKeyRecorders()
        setupProtectFavoritesCheckbox()
        setupAutoLoginControl()
    }
}
