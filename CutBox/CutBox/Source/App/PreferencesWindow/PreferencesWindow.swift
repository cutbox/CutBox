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
import ServiceManagement

extension PreferencesWindow: RecordViewDelegate {

    func recordView(_ recordView: RecordView, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        return true
    }

    func recordViewShouldBeginRecording(_ recordView: RecordView) -> Bool {
        // TODO: Send this change as an event.
        hotKeyCenter
            .unregisterHotKey(with: searchKeyComboUserDefaults)
        return true
    }

    func recordView(_ recordView: RecordView, didChangeKeyCombo keyCombo: KeyCombo) {
        switch recordView {
        case keyRecorder:
            // TODO: Send this change as an event.
            hotKeyService
                .searchKeyCombo
                .onNext(keyCombo)
        default: break
        }
    }

    func recordViewDidClearShortcut(_ recordView: RecordView) {

    }

    func recordViewDidEndRecording(_ recordView: RecordView) {
        // TODO: Send this change as an event.
        if hotKeyCenter.hotKey(searchKeyComboUserDefaults) == nil {
            hotKeyService.resetDefaultGlobalToggle()
        }
    }
}

class PreferencesWindow: NSWindow {

    let searchKeyComboUserDefaults = Constants.searchKeyComboUserDefaults
    let hotKeyService = HotKeyService.shared
    let hotKeyCenter = HotKeyCenter.shared
    let disposeBag = DisposeBag()

    @IBOutlet weak
    var keyRecorder: RecordView!

    override func awakeFromNib() {
        self.titlebarAppearsTransparent = true

        keyRecorder.delegate = self

        // TODO: Send this change as an event.
        hotKeyService
            .searchKeyCombo
            .subscribe(onNext: { self.keyRecorder.keyCombo = $0 })
            .disposed(by: disposeBag)
    }

    @IBAction func setAutoLogin(sender: NSButton) {
        let autoLogin = sender.state == .on
        // TODO: Send this change as an event.
        let appBundleIdentifier = "info.ocodo.CutBoxHelper" as CFString
        if SMLoginItemSetEnabled(appBundleIdentifier, autoLogin) {
            NSLog("Successfully \(autoLogin ? "added" : "removed") login item \(appBundleIdentifier)")
        } else {
            NSLog("Failed to configure login item \(appBundleIdentifier).")
        }
    }
}
