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

    @IBOutlet weak var useCompactUI: NSMenuItem!
    @IBOutlet weak var fuzzyMatchModeItem: NSMenuItem!
    @IBOutlet weak var regexpModeItem: NSMenuItem!
    @IBOutlet weak var regexpCaseSensitiveModeItem: NSMenuItem!
    @IBOutlet weak var statusMenu: NSMenu!

    @IBAction func searchClicked(_ sender: NSMenuItem) {
        self.searchViewController.togglePopup()
    }

    @IBAction func clearHistoryClicked(_ sender: NSMenuItem?) {
        if suppressibleConfirmationDialog(
            messageText: "confirm_warning_clear_history_title".l7n,
            informativeText: "confirm_warning_clear_history".l7n,
            dialogName: "clearHistoryWarning") {
            self.searchViewController.pasteboardService.clear()
        }
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

    @IBAction func useCompactUIClicked(_ sender: NSMenuItem) {
        self.prefs.useCompactUI = !self.prefs.useCompactUI
        self.setCompactUIMenuItem()
    }

    @IBAction func searchModeSelect(_ sender: NSMenuItem) {
        searchModeSelect(sender.accessibilityIdentifier())
    }

    override init() {
        self.searchViewController = SearchViewController()
        super.init()
        self.hotKeyService.configure(controller: self)
        self.prefs
            .events
            .subscribe(onNext: {
                if case CutBoxPreferencesEvent.historyLimitChanged(let limit) = $0 {
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

        setModeSelectors()
        setCompactUIMenuItem()
    }

    func setCompactUIMenuItem() {
        self.useCompactUI.state = self.prefs.useCompactUI ? .on : .off
    }

    func setModeSelectors() {
        self.searchModeSelectors =
            [fuzzyMatchModeItem,
             regexpModeItem,
             regexpCaseSensitiveModeItem]

        self.searchModeSelectorsDict = [
                "fuzzyMatch":fuzzyMatchModeItem,
                "regexpAnyCase":regexpModeItem,
                "regexpStrictCase":regexpCaseSensitiveModeItem
        ]

        checkSearchModeItem(
            PasteboardService
            .shared
            .searchMode
            .axID()
        )

        searchViewController
            .events
            .asObservable()
            .subscribe(onNext: { event in
                switch event {
                case .toggleSearchMode:
                    self.checkSearchModeItem()
                case .setSearchMode(let mode):
                    self.checkSearchModeItem(mode.axID())
                case .clearHistory:
                    self.clearHistoryClicked(nil)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    func searchModeSelect(_ axID: String) {
        let mode = PasteboardSearchMode.searchMode(from: axID)
        searchViewController.events.onNext(.setSearchMode(mode))
    }

    func checkSearchModeItem() {
        let axID = pasteboardService.searchMode.axID()
        searchModeSelectors?.forEach { $0.state = .off }
        searchModeSelectorsDict?[axID]?.state = .on
    }

    func checkSearchModeItem(_ axID: String) {
        searchModeSelectors?.forEach { $0.state = .off }
        searchModeSelectorsDict?[axID]?.state = .on
    }
}
