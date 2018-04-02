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

class PreferencesWindow: NSWindow, RecordViewDelegate {

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        return true
    }

    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        debugPrint("recordView::recordViewShouldBeginRecording")
        HotKeyCenter
            .shared
            .unregisterHotKey(with: "CutBoxToggleSearchPanel")
        return true
    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
        debugPrint("recordView::didChangeKeyCombo")
        switch recordView {
        case keyRecorder:
            CutBoxPreferences
                .shared
                .changeGlobalToggle(keyCombo: keyCombo)
        default: break
        }
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {

    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
        guard HotKeyCenter.shared.hotKey("CutBoxToggleSearchPanel") != nil else {

            CutBoxPreferences.shared.resetDefaultGlobalToggle()
            self.keyRecorder.keyCombo = CutBoxPreferences.shared.globalKeyCombo

            return
        }
    }

    @IBOutlet weak var keyRecorder: RecordView!

    override func awakeFromNib() {
        if #available(OSX 10.10, *) {
            self.titlebarAppearsTransparent = true
        }

        keyRecorder.delegate = self
        keyRecorder.keyCombo = CutBoxPreferences.shared.globalKeyCombo
    }


}
