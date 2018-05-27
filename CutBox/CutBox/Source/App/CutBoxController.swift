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

    @IBOutlet weak var useCompactUI: NSMenuItem!
    @IBOutlet weak var fuzzyMatchModeItem: NSMenuItem!
    @IBOutlet weak var regexpModeItem: NSMenuItem!
    @IBOutlet weak var regexpCaseSensitiveModeItem: NSMenuItem!
    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem: NSStatusItem = NSStatusBar
        .system
        .statusItem(withLength: NSStatusItem.variableLength)

    var searchModeSelectors: [NSMenuItem]?
    var searchModeSelectorsDict: [String:NSMenuItem]?

    let searchViewController: SearchViewController
    let jsFuncSearchViewController: JSFuncSearchViewController
    let preferencesController: PreferencesTabViewController
    let aboutPanel: AboutPanel = AboutPanel.fromNib()!

    let hotKeyService = HotKeyService.shared
    let prefs = CutBoxPreferencesService.shared
    let historyService = HistoryService.shared

    private let disposeBag = DisposeBag()

    @IBAction func searchClicked(_ sender: NSMenuItem) {
        self.searchViewController.togglePopup()
    }

    @IBAction func clearHistoryClicked(_ sender: NSMenuItem?) {
        if suppressibleConfirmationDialog(
            messageText: "confirm_warning_clear_history_title".l7n,
            informativeText: "confirm_warning_clear_history".l7n,
            dialogName: "clearHistoryWarning") {
            self.searchViewController.historyService.clear()
        }
    }

    @IBAction func openPreferences(_ sender: NSMenuItem) {
        NSApplication.shared.activate(ignoringOtherApps: true)
        preferencesController.open()
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
    }

    @IBAction func searchModeSelect(_ sender: NSMenuItem) {
        searchModeSelect(sender.accessibilityIdentifier())
    }

    override init() {
        self.searchViewController = SearchViewController()
        self.jsFuncSearchViewController = JSFuncSearchViewController()
        self.preferencesController = PreferencesTabViewController()
        super.init()
    }

    override func awakeFromNib() {
        let icon = #imageLiteral(resourceName: "statusIcon") // invisible on dark xcode source theme
        icon.isTemplate = true // best for dark mode
        self.statusItem.image = icon
        self.statusItem.menu = statusMenu
        self.hotKeyService.configure(controller: self)

        setSearchEventBindings()
        setPreferencesEventBindings()
        setModeSelectors()
        setCompactUIMenuItem()
    }

    func setSearchEventBindings() {
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
                case .selectJavascriptFunction:
                    self.openJavascriptPopup()
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    func openJavascriptPopup() {
        let items = self.searchViewController.selectedClips
        self.jsFuncSearchViewController.selectedClips = items

        self.jsFuncSearchViewController
            .jsFuncView
            .applyTheme()

        self.jsFuncSearchViewController
            .jsFuncPopup
            .togglePopup()
    }

    func setPreferencesEventBindings() {
        self.prefs
            .events
            .subscribe(onNext: {
                switch $0 {
                case .historyLimitChanged(let limit):
                    self.historyService.historyLimit = limit
                case .compactUISettingChanged(let isOn):
                    self.useCompactUI.state = isOn ? .on : .off
                default:
                    break
                }
            })
            .disposed(by: disposeBag)
    }

    func setCompactUIMenuItem() {
        self.useCompactUI.title = "preferences_use_compact_ui".l7n
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
            HistoryService
                .shared
                .searchMode
                .axID()
        )
    }

    func searchModeSelect(_ axID: String) {
        let mode = HistorySearchMode.searchMode(from: axID)
        searchViewController.events.onNext(.setSearchMode(mode))
    }

    func checkSearchModeItem() {
        let axID = historyService.searchMode.axID()
        searchModeSelectors?.forEach { $0.state = .off }
        searchModeSelectorsDict?[axID]?.state = .on
    }

    func checkSearchModeItem(_ axID: String) {
        searchModeSelectors?.forEach { $0.state = .off }
        searchModeSelectorsDict?[axID]?.state = .on
    }
}
