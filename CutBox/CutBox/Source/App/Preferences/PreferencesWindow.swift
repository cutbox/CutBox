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

    @IBOutlet weak var historyLimitTitle: NSTextField!
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
    @IBOutlet weak var themeSelectorMenu: NSPopUpButton!

    @IBOutlet weak var compactUICheckbox: NSButton!

    @IBOutlet weak var protectFavoritesCheckbox: NSButton!

    @IBOutlet weak var javascriptPreferencesContainer: NSStackView!
    @IBOutlet weak var javascriptProcessingSectionTitle: NSTextField!
    @IBOutlet weak var javascriptProcessingNote: NSTextField!
    @IBOutlet weak var javascriptProcessingIsEnabledCheckbox: NSButton!
    @IBOutlet weak var javascriptProcessingTextView: NSTextView!
    @IBOutlet weak var javascriptProcessingSaveScript: NSButton!

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
        setupHistorySizeLabel()
        setupJoinStringTextField()
        setupWrappingStringTextFields()
        setupJavascriptProcessingSection()
    }

    func setupJavascriptProcessingSection() {
        self.javascriptProcessingSectionTitle.stringValue = "preferences_javascript_processing_section_title".l7n
        self.javascriptProcessingNote.stringValue = "preferences_javascript_processing_section_note".l7n

        self.javascriptProcessingIsEnabledCheckbox.title = "preferences_javascript_processing_is_enabled_checkbox".l7n

        self.javascriptProcessingIsEnabledCheckbox
            .rx
            .state
            .map { $0 == .on }
            .subscribe(onNext: { self.prefs.javascriptEnabled = $0 })
            .disposed(by: disposeBag)

        self.javascriptProcessingIsEnabledCheckbox
            .rx
            .state
            .map { $0 != .on }
            .bind(to: self.javascriptPreferencesContainer.rx.isHidden)
            .disposed(by: disposeBag)

        self.javascriptProcessingTextView.string = "preferences_javascript_processing_template".l7n
        self.javascriptProcessingTextView.font = NSFont.userFixedPitchFont(ofSize: 10)
        self.javascriptProcessingTextView.isAutomaticQuoteSubstitutionEnabled = false
        self.javascriptProcessingTextView.isAutomaticTextReplacementEnabled = false
        self.javascriptProcessingTextView.enabledTextCheckingTypes = 0

        self.javascriptProcessingSaveScript
            .rx.tap
            .map { self.javascriptProcessingTextView.string }
            .subscribe(onNext: { self.prefs.javascript = $0 })
            .disposed(by: disposeBag)
    }
}

