//
//  CutBoxController.swift
//  CutBox
//
//  Created by Jason Milkins on 17/3/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa
import Magnet
import RxSwift

class CutBoxController: NSObject {

    let statusItem: NSStatusItem = NSStatusBar
        .system
        .statusItem(withLength: NSStatusItem.variableLength)

    var searchModeSelectors: [NSMenuItem]?
    var searchModeSelectorsDict: [String:NSMenuItem]?

    let searchViewController: SearchViewController
    let preferencesWindow: PreferencesWindow = PreferencesWindow.fromNib()!
    let aboutPanel: AboutPanel = AboutPanel.fromNib()!
    let hotKeyService = HotKeyService.shared

    let prefs = CutBoxPreferencesService.shared
    let pasteboardService = PasteboardService.shared

    private let disposeBag = DisposeBag()

    @IBOutlet weak var fuzzyMatchModeItem: NSMenuItem!
    @IBOutlet weak var regexpModeItem: NSMenuItem!
    @IBOutlet weak var regexpCaseSensitiveModeItem: NSMenuItem!
    @IBOutlet weak var statusMenu: NSMenu!

    @IBAction func searchClicked(_ sender: NSMenuItem) {
        self.searchViewController.togglePopup()
    }

    @IBAction func clearHistoryClicked(_ sender: NSMenuItem) {
        self.searchViewController.pasteboardService.clear()
    }

    @IBAction func openPreferences(_ sender: NSMenuItem) {
        NSApplication.shared.activate(ignoringOtherApps: true)
        preferencesWindow.makeKeyAndOrderFront(self)
        preferencesWindow.center()
    }

    @IBAction func openAboutPanel(_ sender: NSMenuItem) {
        aboutPanel.makeKeyAndOrderFront(self)
        aboutPanel.center()
    }

    @IBAction func quitClicked(_ sender:  NSMenuItem) {
        NSApp.terminate(sender)
    }


    override init() {
        self.searchViewController = SearchViewController()
        super.init()
        self.hotKeyService.configure(controller: self)
        self.prefs
            .events
            .subscribe(onNext: {
                switch $0 {
                case CutBoxPreferencesEvent.historyLimitChanged(let limit):
                    self.pasteboardService.historyLimit = limit
                }
            })
            .disposed(by: disposeBag)
    }

    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "statusIcon") // invisible on dark xcode source theme
        icon.isTemplate = true // best for dark mode
        self.statusItem.image = icon
        self.statusItem.menu = statusMenu

        setupModeSelectors()
    }

    func setupModeSelectors() {
        self.searchModeSelectors =
            [fuzzyMatchModeItem,
             regexpModeItem,
             regexpCaseSensitiveModeItem]

        self.searchModeSelectorsDict =
            [
                "fuzzyMatch":fuzzyMatchModeItem,
                "regexpAnyCase":regexpModeItem,
                "regexpStrictCase":regexpCaseSensitiveModeItem
        ]

        checkSearchModeItem(
            PasteboardService
            .shared
            .searchMode
            .axID())

        searchViewController
            .events
            .asObservable()
            .subscribe(onNext: { event in
                switch event {
                case .setSearchMode(let mode):
                    self.checkSearchModeItem(mode.axID())
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    @IBAction func searchModeSelect(_ sender: NSMenuItem) {
        searchModeSelect(sender.accessibilityIdentifier())
    }

    func searchModeSelect(_ axID: String) {
        let mode = PasteboardSearchMode.searchMode(from: axID)
        searchViewController.events.onNext(.setSearchMode(mode))
    }

    func checkSearchModeItem(_ axID: String) {
        searchModeSelectors?.forEach { $0.state = .off }
        searchModeSelectorsDict?[axID]?.state = .on
    }
}
