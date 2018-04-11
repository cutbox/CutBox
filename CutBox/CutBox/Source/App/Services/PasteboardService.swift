//
//  PasteboardService.swift
//  CutBox
//
//  Created by Jason Milkins on 24/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import SwiftyStringScore

class PasteboardService: NSObject {

    static let shared = PasteboardService()

    var pollingTimer: Timer?
    var filterText: String?

    private var _defaultSearchMode: PasteboardSearchMode = .fuzzyMatch

    var searchMode: PasteboardSearchMode {
        set {
            self.defaults.set(newValue.axID(), forKey: kSearchModeKey)
        }
        get {
            if let axID = self.defaults.string(forKey: kSearchModeKey) {
                return PasteboardSearchMode.searchMode(from: axID)
            }
            return _defaultSearchMode
        }
    }
    var defaults = NSUserDefaultsController.shared.defaults

    private var kSearchModeKey = "searchMode"
    private var kPasteStoreKey = "pasteStore"
    private var pasteStore: [String] = []

    override init() {
        if let pasteStore = defaults.array(forKey: kPasteStoreKey) {
            self.pasteStore = pasteStore as! [String]
        } else {
            self.pasteStore = []
        }

        super.init()
    }

    var items: [String] {
        guard let search = self.filterText, search != ""
            else { return pasteStore }

        switch searchMode {
        case .fuzzyMatch:
            return pasteStore.fuzzySearchRankedFiltered(
                search: search,
                score: Constants.searchFuzzyMatchMinScore)
        case .regexpAnyCase:
            return pasteStore.regexpSearchFiltered(
                search: search,
                options: [.caseInsensitive])
        case .regexpStrictCase:
            return pasteStore.regexpSearchFiltered(
                search: search,
                options: [])

        }
    }

    var count: Int {
        return items.count
    }

    subscript (indexes: IndexSet) -> [String] {
        return items[indexes]
    }

    subscript (index: Int) -> String? {
        return items[safe: index]
    }

    func startTimer() {
        guard pollingTimer == nil else { return }
        pollingTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                            target: self,
                                            selector: #selector(self.pollPasteboard),
                                            userInfo: nil,
                                            repeats: true)
    }

    func stopTimer() {
        guard pollingTimer != nil else { return }
        pollingTimer?.invalidate()
        pollingTimer = nil
    }

    func replaceWithLatest() -> String? {
        guard let currentClip = clipboardContent() else { return nil }

        if let indexOfClip = pasteStore.index(of: currentClip) {
            pasteStore.remove(at: indexOfClip)
        }

        return pasteStore.first == currentClip ? nil : currentClip
    }

    func toggleSearchMode() {
        self.searchMode = self.searchMode.next()
    }

    func clear() {
        clearDefaults()
        pasteStore = []
    }

    func remove(at index: Int) {
        pasteStore.remove(at: index)
        self.saveToDefaults()
    }

    func clearDefaults() {
        defaults.removeObject(forKey: kPasteStoreKey)
    }

    func saveToDefaults() {
        defaults.set(self.pasteStore, forKey: kPasteStoreKey)
    }

    deinit {
        self.stopTimer()
    }

    func clipboardContent() -> String? {
        return NSPasteboard.general
            .pasteboardItems?.first?
            .string(forType: .string)
    }

    @objc func pollPasteboard() {
        if let clip = self.replaceWithLatest() {
            self.pasteStore.insert(clip, at: 0)
            self.saveToDefaults()
        }
    }
}

