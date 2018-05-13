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
    @IBOutlet weak var tabView: PreferencesTabView!

    override func awakeFromNib() {
        self.title = "preferences_title".l7n
        self.titlebarAppearsTransparent = true
    }
}

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

class PreferencesJavascriptProcessingView: NSView {
    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var javascriptProcessingSectionTitle: NSTextField!
    @IBOutlet weak var javascriptProcessingNote: NSTextField!
    @IBOutlet weak var javascriptProcessingTextView: NSTextView!
    @IBOutlet weak var javascriptProcessingSaveScript: NSButton!

    override func awakeFromNib() {
        self.prefs = CutBoxPreferencesService.shared

        setupJavascriptProcessingSection()
    }

    func setupJavascriptProcessingSection() {
        self.javascriptProcessingSectionTitle.stringValue = "preferences_javascript_processing_section_title".l7n
        self.javascriptProcessingNote.stringValue = "preferences_javascript_processing_section_note".l7n
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

class PreferencesAdvancedView: NSView {
    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var historyLimitTitle: NSTextField!
    @IBOutlet weak var historyLimitTextField: NSTextField!
    @IBOutlet weak var historyUnlimitedCheckbox: NSButton!
    @IBOutlet weak var historySizeLabel: NSTextField!

    @IBOutlet weak var joinAndWrapSectionTitle: NSTextField!
    @IBOutlet weak var joinAndWrapNote: NSTextFieldCell!
    @IBOutlet weak var joinClipsTitle: NSTextField!
    @IBOutlet weak var joinStyleSelector: NSSegmentedControl!
    @IBOutlet weak var joinStringTextField: NSTextField!

    @IBOutlet weak var shouldWrapMultipleSelection: NSButton!
    @IBOutlet weak var wrapStartTextField: NSTextField!
    @IBOutlet weak var wrapEndTextField: NSTextField!

    override func awakeFromNib() {
        prefs = CutBoxPreferencesService.shared

        setupWrappingStringTextFields()
        setupJoinStringTextField()
        setupHistoryLimitControls()
        setupHistorySizeLabel()
    }

    @IBAction func joinStyleSelectorAction(_ sender: Any) {
        if let selector: NSSegmentedControl = sender as? NSSegmentedControl {
            let bool = selector.selectedSegment == 1
            joinStringTextField.isHidden = !bool
            joinStringTextField.isEnabled = bool
            prefs.useJoinString = bool
        }
    }
}

class PreferencesThemeSelectionView: NSView {
    var prefs: CutBoxPreferencesService!
    let disposeBag = DisposeBag()

    @IBOutlet weak var themeSelectorTitleLabel: NSTextField!
    @IBOutlet weak var themeSelectorMenu: NSPopUpButton!
    @IBOutlet weak var compactUICheckbox: NSButton!

    override func awakeFromNib() {
        prefs = CutBoxPreferencesService.shared

        setupThemeSelector()
        setupCompactUIControl()
    }

    @IBAction func themeSelectorMenuChanges(_ sender: NSPopUpButton) {
        prefs.theme = sender.index(of: sender.selectedItem!)
    }
}


