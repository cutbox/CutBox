//
//  PreferencesWindow.swift
//  CutBox
//
//  Created by Jason on 31/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import KeyHolder
import Magnet
import RxSwift
import RxCocoa

extension PreferencesWindow: RecordViewDelegate {

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        return true
    }

    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        hotKeyCenter
            .unregisterHotKey(with: searchKeyComboUserDefaults)
        return true
    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
        switch recordView {
        case keyRecorder:
            hotKeyService
                .searchKeyCombo
                .onNext(keyCombo)
        default: break
        }
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {

    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
        if hotKeyCenter.hotKey(searchKeyComboUserDefaults) == nil {
            hotKeyService.resetDefaultGlobalToggle()
        }
    }
}

class PreferencesWindow: NSWindow {

    let searchKeyComboUserDefaults = Constants.searchKeyComboUserDefaults
    let hotKeyService = HotKeyService.shared
    let hotKeyCenter = HotKeyCenter.shared
    let loginItemsService = LoginItemsService.shared
    let disposeBag = DisposeBag()

    @IBOutlet weak var autoLoginCheckbox: NSButton!
    @IBOutlet weak var keyRecorder: RecordView!

    override func awakeFromNib() {
        self.titlebarAppearsTransparent = true

        self.keyRecorder.delegate = self

        self.hotKeyService
            .searchKeyCombo
            .subscribe(onNext: { self.keyRecorder.keyCombo = $0 })
            .disposed(by: self.disposeBag)

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

