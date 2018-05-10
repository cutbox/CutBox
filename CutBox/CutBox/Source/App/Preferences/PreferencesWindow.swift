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

    @IBOutlet weak var historySizeLabel: NSTextField!
    @IBOutlet weak var historyLimitTextField: NSTextField!
    @IBOutlet weak var historyUnlimitedCheckbox: NSButton!
    @IBOutlet weak var joinAndWrapSectionTitle: NSTextField!
    @IBOutlet weak var joinAndWrapNote: NSTextFieldCell!
    @IBOutlet weak var joinClipsTitle: NSTextField!
    @IBOutlet weak var joinStyleSelector: NSSegmentedControl!
    @IBOutlet weak var joinStringTextField: NSTextField!
    @IBOutlet weak var autoLoginCheckbox: NSButton!
    @IBOutlet weak var mainKeyRecorder: RecordView!
    @IBOutlet weak var mainKeyRecorderLabel: NSTextField!
    @IBOutlet weak var shouldWrapMultipleSelection: NSButton!
    @IBOutlet weak var wrapStartTextField: NSTextField!
    @IBOutlet weak var wrapEndTextField: NSTextField!
    @IBOutlet weak var themeSelectorTitleLabel: NSTextField!
    @IBOutlet weak var historyLimitTitle: NSTextField!
    @IBOutlet weak var themeSelectorMenu: NSPopUpButton!
    @IBOutlet weak var compactUICheckbox: NSButton!
    @IBOutlet weak var protectFavoritesCheckbox: NSButton!

    @IBAction func themeSelectorMenuChanges(_ sender: NSPopUpButton) {
        prefs.theme = sender.index(of: sender.selectedItem!)
    }

    override func awakeFromNib() {
        self.title = "preferences_title".l7n

        self.loginItemsService = LoginItemsService.shared
        self.hotKeyService = HotKeyService.shared
        self.hotKeyCenter = HotKeyCenter.shared
        self.prefs = CutBoxPreferencesService.shared

        self.titlebarAppearsTransparent = true

        setupAutoLoginControl()
        setupCompactUIControl()
        setupProtectFavoritesCheckbox()
        setupThemeSelector()
        setupKeyRecorders()
        setupHistoryLimitControls()
        setupJoinStringTextField()
        setupWrappingStringTextFields()
        setupHistorySizeLabel()
    }

    func setupHistorySizeLabel() {
        updateHistorySizeLabel()

        HistoryService.shared
            .events
            .subscribe(onNext: { _ in self.updateHistorySizeLabel() })
            .disposed(by: disposeBag)
    }

    func updateHistorySizeLabel() {
        self.historySizeLabel.stringValue = String(
            format: "preferences_history_is_using_format".l7n,
            HistoryService.shared.bytesFormatted()
        )
    }

    func setupThemeSelector() {
        self.themeSelectorTitleLabel.stringValue =
            "preferences_color_theme_title".l7n

        self.themeSelectorMenu.addItems(withTitles:
            CutBoxColorTheme.instances.map { $0.name }
        )

        self.themeSelectorMenu.selectItem(at: prefs.theme)
    }
}
