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

        prefs.setTheme(theme: sender.selectedSegment)
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

extension PreferencesWindow {
    func setupWrappingStringTextFields() {
        let (start, end) = CutBoxPreferences.shared.wrappingStrings
        self.wrapStartTextField.stringValue = start ?? ""
        self.wrapEndTextField.stringValue = end ?? ""

        let shouldWrapSaved = CutBoxPreferences.shared.useWrappingStrings
        self.shouldWrapMultipleSelection.state = shouldWrapSaved ? .on : .off
        updateWrappingMultipleSelection(shouldWrapSaved)

        Observable
            .combineLatest(self.wrapStartTextField.rx.text,
                           self.wrapEndTextField.rx.text)
            { ($0, $1) }
            .skip(1)
            .subscribe(onNext: { CutBoxPreferences.shared.wrappingStrings = $0 })
            .disposed(by: disposeBag)

        self.shouldWrapMultipleSelection.rx.state
            .skip(1)
            .map { $0 == .on }
            .subscribe(onNext: { self.updateWrappingMultipleSelection($0) })
            .disposed(by: disposeBag)
    }

    func updateWrappingMultipleSelection(_ bool: Bool) {
        CutBoxPreferences.shared.useWrappingStrings = bool
        [self.wrapStartTextField,
         self.wrapEndTextField]
            .forEach { $0?.isEnabled = bool }
    }
}

extension PreferencesWindow {
    @IBAction func joinStyleSelectorAction(_ sender: Any) {
        if let selector: NSSegmentedControl = sender as? NSSegmentedControl {
            let bool = selector.selectedSegment == 1
            joinStringTextField.isEnabled = bool
            CutBoxPreferences.shared.useJoinString = bool
        }
    }

    func setupJoinStringTextField()  {
        let useJoinString = CutBoxPreferences.shared.useJoinString

        joinStyleSelector.selectSegment(withTag: useJoinString ? 1 : 0 )

        if let joinString = CutBoxPreferences.shared.multiJoinString {
            joinStringTextField.stringValue = joinString
            joinStringTextField.isEnabled = useJoinString
        }

        self.joinStringTextField.rx.text
            .distinctUntilChanged { lhs, rhs in rhs == lhs }
            .subscribe(onNext: { text in
                if self.joinStringTextField.isEnabled {
                    CutBoxPreferences.shared.multiJoinString = text
                }
            })
            .disposed(by: disposeBag)
    }
}

extension PreferencesWindow {
    func setupKeyRecorders() {
        self.mainKeyRecorder.delegate = self

        self.hotKeyService
            .searchKeyCombo
            .subscribe(onNext: { self.mainKeyRecorder.keyCombo = $0 })
            .disposed(by: self.disposeBag)
    }
}

extension PreferencesWindow {
    func setupAutoLoginControl() {
        self.loginItemsService
            .autoLoginEnabled
            .asObservable()
            .bind(to: self.autoLoginCheckbox.rx.state )
            .disposed(by: disposeBag)

        self.autoLoginCheckbox.rx.state
            .bind(to: self.loginItemsService.autoLoginEnabled)
            .disposed(by: disposeBag)
    }
}

extension PreferencesWindow: RecordViewDelegate {

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        return true
    }

    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        hotKeyCenter
            .unregisterHotKey(with: Constants.kCutBoxToggleKeyCombo)
        return true
    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
        switch recordView {
        case mainKeyRecorder:
            hotKeyService
                .searchKeyCombo
                .onNext(keyCombo)
        default: break
        }
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {

    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
        if hotKeyCenter.hotKey(Constants.kCutBoxToggleKeyCombo) == nil {
            hotKeyService.resetDefaultGlobalToggle()
        }
    }
}
