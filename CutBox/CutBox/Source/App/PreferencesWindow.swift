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
    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        debugPrint("recordView::recordViewShouldBeginRecording")
        return true
    }

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        debugPrint("recordView::canRecordKeyCombo")
        return true
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {
        debugPrint("recordView::recordViewDidClearShortcut")
    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
        debugPrint("recordView::recordViewDidEndRecording")
    }


    @IBOutlet weak var keyRecorder: RecordView!

    override func awakeFromNib() {
        keyRecorder.keyCombo = CutBoxPreferences.shared.globalHotkey

    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
        debugPrint("recordView::didChangeKeyCombo")
//        HotKeyCenter.shared.unregisterHotKey(with: "a")
    }
}
