//
//  PreferencesWindow+KeyRecorder.swift
//  CutBox
//
//  Created by Jason on 11/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Magnet
import KeyHolder
import RxSwift

extension PreferencesWindow {
    func setupKeyRecorders() {
        self.mainKeyRecorder.delegate = self
        self.mainKeyRecorderLabel.stringValue = "preferences_toggle_cutbox".l7n

        self.hotKeyService
            .searchKeyCombo
            .subscribe(onNext: { self.mainKeyRecorder.keyCombo = $0 })
            .disposed(by: self.disposeBag)
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
