//
//  PasteboardService.swift
//  CutBox
//
//  Created by Jason Milkins on 24/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

class PasteboardService: NSObject {

    var pollingTimer: Timer?
    var filterText: String?
    var newItem = false

    private var pasteStore: [String] = []

    var items: [String] {
        guard let filterText = self.filterText,
            filterText != "" else { return pasteStore }

        return pasteStore
            .flatMap { $0.lowercased().contains(filterText.lowercased()) ? $0 : nil }
    }

    var count: Int {
        return items.count
    }

    subscript (index: Int) -> String? {
        return items[safe: index]
    }

    func startTimer() {
        guard pollingTimer == nil else { return }
        pollingTimer = Timer.scheduledTimer(timeInterval: 0.1,
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

        guard let latestStored = self.pasteStore.first else {
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
            self.pasteStore.insert(clip, at: 0)
        }
    }
}
