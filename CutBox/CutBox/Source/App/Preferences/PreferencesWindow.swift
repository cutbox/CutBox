//
//  PreferencesWindow.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import AppKit
import KeyHolder
import Magnet
import RxSwift
import RxCocoa

class PreferencesWindow: NSWindow {

    var loginItemsService: LoginItemsService!
    var hotKeyService: HotKeyService!
    var hotKeyCenter: HotKeyCenter!
    var prefs: CutBoxPreferencesService!

    let disposeBag = DisposeBag()

    @IBOutlet weak var historyLimitTextField: NSTextField!
    @IBOutlet weak var historyUnlimitedCheckbox: NSButton!
    @IBOutlet weak var joinStyleSelector: NSSegmentedControl!
    @IBOutlet weak var joinStringTextField: NSTextField!
    @IBOutlet weak var autoLoginCheckbox: NSButton!
    @IBOutlet weak var mainKeyRecorder: RecordView!
    @IBOutlet weak var shouldWrapMultipleSelection: NSButton!
    @IBOutlet weak var wrapStartTextField: NSTextField!
    @IBOutlet weak var wrapEndTextField: NSTextField!
    @IBOutlet weak var themeSelector: NSSegmentedControl!

    @IBAction func themeSelectorChanges(_ sender: NSSegmentedControl) {
        prefs.theme = sender.selectedSegment
    }

    override func awakeFromNib() {
        self.loginItemsService = LoginItemsService.shared
        self.hotKeyService = HotKeyService.shared
        self.hotKeyCenter = HotKeyCenter.shared
        self.prefs = CutBoxPreferencesService.shared

        self.titlebarAppearsTransparent = true

        setupHistoryLimitControls()
        setupKeyRecorders()
        setupAutoLoginControl()
        setupJoinStringTextField()
        setupWrappingStringTextFields()
        setupThemeSelector()
    }

    func setupThemeSelector() {
        self.themeSelector.selectedSegment = prefs.theme
    }
}
