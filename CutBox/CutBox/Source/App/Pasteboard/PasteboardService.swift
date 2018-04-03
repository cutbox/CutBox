//
//  PasteboardService.swift
//  CutBox
//
//  Created by Jason Milkins on 24/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import SwiftyStringScore

enum PasteboardServiceEvents {
    case replacedItem
}

class PasteboardService: NSObject {

    static let shared = PasteboardService()

    var pollingTimer: Timer?
    var filterText: String?

    private var kPasteStoreKey = "pasteStore"
    private var pasteStore: [String] = []

    override init() {
        if let pasteStore = NSUserDefaultsController
            .shared
            .defaults
            .array(forKey: kPasteStoreKey) {
            self.pasteStore = pasteStore as! [String]
        } else {
            self.pasteStore = []
        }
        super.init()
    }

    var items: [String] {
        guard let search = self.filterText,
            search != "" else { return pasteStore }
        let minScore = Constants.searchFuzzyMatchMinScore

        return pasteStore
            .map { ($0, $0.score(word: search)) }
            .filter { $0.1 > minScore }
            .sorted { $0.1 > $1.1 }
            .map { $0.0 }
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

    func hasAtIndex(_ clip: String) -> Int? {
        return pasteStore.index(of: clip)
    }

    func replaceWithLatest() -> String? {
        guard let currentClip = clipboardContent() else { return nil }

        if let indexOfClip = hasAtIndex(currentClip) {
            pasteStore.remove(at: indexOfClip)
        }

        return currentClip
    }

    func clear() {
        clearDefaults()
        pasteStore = []
    }

    func clearDefaults() {
        NSUserDefaultsController
            .shared
            .defaults
            .removeObject(forKey: kPasteStoreKey)
    }

    func saveToDefaults() {
        NSUserDefaultsController
            .shared
            .defaults
            .set(self.pasteStore,
                 forKey: kPasteStoreKey)
    }

    deinit {
        self.stopTimer()
    }

    func clipboardContent() -> String? {
        return NSPasteboard
            .general
            .pasteboardItems?
            .first?
            .string(forType: .string)
    }

    @objc func pollPasteboard() {
        if let clip = self.replaceWithLatest() {
            self.pasteStore.insert(clip, at: 0)
        }
    }
}

