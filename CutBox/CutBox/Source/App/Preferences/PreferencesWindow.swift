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

    override func awakeFromNib() {
        self.titlebarAppearsTransparent = true

        setupKeyRecorders()
        setupAutoLoginControl()
        setupJoinStringTextField()
    }
}

extension PreferencesWindow {
    func setupJoinStringTextField()  {

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

    @IBAction func joinStyleSelectorAction(_ sender: Any) {
        if let selector: NSSegmentedControl = sender as? NSSegmentedControl {
            let bool = selector.selectedSegment == 1
            joinStringTextField.isEnabled = bool
            CutBoxPreferences.shared.useJoinString = bool
        }
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
