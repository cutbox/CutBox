//
//  PasteboardService.swift
//  CutBox
//
//  Created by Jason on 24/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class PasteboardService {

    var pollingTimer: Timer?
    var newItem = false

    private var pasteStore: [String?] = []

    func startTimer() {
        guard pollingTimer == nil else { return }
        pollingTimer = Timer.scheduledTimer(timeInterval: 1,
                                            target: self,
                                            selector: #selector(pollPasteboard),
                                            userInfo: nil,
                                            repeats: true)
    }

    func stopTimer() {
        guard pollingTimer != nil else { return }
        pollingTimer?.invalidate()
        pollingTimer = nil
    }

    func checkClip() -> String? {
        guard let currentClip = clipboardContent() else {
            self.newItem = false
            return nil
        }

        guard let latestStored = self.pasteStore.last else {
            self.newItem = true
            return currentClip
        }

        if latestStored != currentClip {
            self.newItem = true
            return currentClip
        } else {
            self.newItem = false
            return nil
        }
    }

    deinit {
        self.stopTimer()
    }

    func clipboardContent() -> String? {
        return NSPasteboard.general.pasteboardItems?.first?.string(forType: .string)
    }

    @objc func pollPasteboard() {
        if let clip = self.checkClip() {
            self.pasteStore.append(clip)
            debugPrint("--------- --------- --------")
            debugPrint(self.pasteStore)
        }
    }
}
