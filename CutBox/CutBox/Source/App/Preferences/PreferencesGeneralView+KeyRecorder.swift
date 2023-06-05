//
//  PreferencesGeneralView+KeyRecorder.swift
//  CutBox
//
//  Created by Jason Milkins on 11/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Magnet
import KeyHolder
import RxSwift

extension PreferencesGeneralView {

    func setupKeyRecorders() {
        self.mainKeyRecorder.delegate = self
        self.mainKeyRecorder.clearButtonMode = .never
        self.mainKeyRecorderLabel.stringValue = "preferences_toggle_cutbox".l7n
        self.mainKeyRecorderLabel.toolTip = "preferences_toggle_cutbox_tooltip".l7n

        self.hotKeyService
            .searchKeyCombo
            .subscribe(onNext: { self.mainKeyRecorder.keyCombo = $0 })
            .disposed(by: self.disposeBag)
    }
}

extension PreferencesGeneralView: RecordViewDelegate {

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        return true
    }

    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        hotKeyCenter
            .unregisterHotKey(with: Constants.cutBoxToggleKeyCombo)
        return true
    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo?) {
        switch recordView {
        case mainKeyRecorder:
            hotKeyService
                .searchKeyCombo
                .onNext(keyCombo!)
        default: break
        }
    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
    }
}
