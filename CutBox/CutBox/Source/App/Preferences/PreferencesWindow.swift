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

    let loginItemsService = LoginItemsService.shared
    let hotKeyService = HotKeyService.shared
    let hotKeyCenter = HotKeyCenter.shared
    let disposeBag = DisposeBag()

    @IBOutlet weak var joinStyleSelector: NSSegmentedControl!
    @IBOutlet weak var joinStringTextField: NSTextField!
    @IBOutlet weak var autoLoginCheckbox: NSButton!
    @IBOutlet weak var mainKeyRecorder: RecordView!
    @IBOutlet weak var shouldWrapMultipleSelection: NSButton!
    @IBOutlet weak var wrapStartTextField: NSTextField!
    @IBOutlet weak var wrapEndTextField: NSTextField!
    @IBOutlet weak var themeSelector: NSSegmentedControl!

    @IBAction func themeSelectorChanges(_ sender: NSSegmentedControl) {
        let prefs = CutBoxPreferences.shared

        prefs.theme = sender.selectedSegment
    }

    override func awakeFromNib() {
        self.titlebarAppearsTransparent = true

        setupKeyRecorders()
        setupAutoLoginControl()
        setupJoinStringTextField()
        setupWrappingStringTextFields()
        setupThemeSelector()
    }

    func setupThemeSelector() {
        self.themeSelector.selectedSegment = CutBoxPreferences.shared.theme
    }
}
