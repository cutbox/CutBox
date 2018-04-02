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

class PreferencesWindow: NSWindow, RecordViewDelegate {

    let prefs = CutBoxPreferences.shared
    let disposeBag = DisposeBag()

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        return true
    }

    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        HotKeyCenter
            .shared
            .unregisterHotKey(with: prefs.searchKeyComboUserDefaults)
        return true
    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
        switch recordView {
        case keyRecorder:
            prefs.searchCustomKeyCombo
                .onNext(keyCombo)
        default: break
        }
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {

    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
        if HotKeyCenter.shared.hotKey(prefs.searchKeyComboUserDefaults) == nil {
            self.prefs.resetDefaultGlobalToggle()
        }
    }

    @IBOutlet weak var keyRecorder: RecordView!

    override func awakeFromNib() {
        self.titlebarAppearsTransparent = true

        keyRecorder.delegate = self
        CutBoxPreferences.shared
            .searchCustomKeyCombo
            .subscribe(onNext: {
                self.keyRecorder.keyCombo = $0
            })
            .disposed(by: disposeBag)
    }
}
