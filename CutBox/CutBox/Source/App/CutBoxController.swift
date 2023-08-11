//
//  CutBoxController.swift
//  CutBox
//
//  Created by Jason Milkins on 17/3/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Cocoa

import RxSwift

typealias StatusItemDescriptor = (Int, String, String?, String?)

class CutBoxController: NSObject {

    var useCompactUI: NSMenuItem!
    var hidePreview: NSMenuItem!
    var fuzzyMatchModeItem: NSMenuItem!
    var regexpModeItem: NSMenuItem!
    var regexpCaseSensitiveModeItem: NSMenuItem!

    @IBOutlet weak var statusMenu: NSMenu!

    let statusItem: NSStatusItem = NSStatusBar
        .system
        .statusItem(withLength: NSStatusItem.variableLength)

    var searchModeSelectors: [NSMenuItem]?
    var searchModeSelectorsDict: [String: NSMenuItem]?

    let searchViewController: SearchViewController
    let jsFuncSearchViewController: JSFuncSearchViewController
    let preferencesController: PreferencesTabViewController
    let aboutPanel: AboutPanel = AboutPanel.fromNib()!

    let hotKeyService = HotKeyService.shared
    let prefs = CutBoxPreferencesService.shared
    let historyService = HistoryService.shared

    private let disposeBag = DisposeBag()

    @objc func searchClicked(_ sender: NSMenuItem) {
        self.searchViewController.togglePopup()
    }

    @objc func clearHistoryClicked(_ sender: NSMenuItem?) {
        if suppressibleConfirmationDialog(
            messageText: "confirm_warning_clear_history_title".l7n,
            informativeText: "confirm_warning_clear_history".l7n,
            dialogName: "clearHistoryWarning") {
            self.searchViewController.historyService.clear()
        }
    }

    @objc func openPreferences(_ sender: NSMenuItem) {
        NSApplication.shared.activate(ignoringOtherApps: true)
        preferencesController.open()
    }

    @objc func openAboutPanel(_ sender: NSMenuItem) {
        aboutPanel.makeKeyAndOrderFront(self)
        aboutPanel.center()
    }

    @objc func quitClicked(_ sender: NSMenuItem) {
        NSApp.terminate(sender)
    }

    @objc func useCompactUIClicked(_ sender: NSMenuItem) {
        self.prefs.useCompactUI = !self.prefs.useCompactUI
    }

    @objc func hidePreviewClicked(_ sender: NSMenuItem) {
        self.prefs.hidePreview = !self.prefs.hidePreview
    }

    @objc func searchModeSelect(_ sender: NSMenuItem) {
        searchModeSelectAxID(sender.accessibilityIdentifier())
    }

    @objc func reloadJavascript(_ sender: NSMenuItem) {
        self.prefs.loadJavascript()
    }

    @objc func reloadThemes(_ sender: NSMenuItem) {
        self.prefs.loadThemes()
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
        self.hotKeyService.configure()

        setHotKeyServiceEventBindings()
        setSearchEventBindings()
        setPreferencesEventBindings()
        setMenuItems()
    }

    func setMenuItems() {
        let icon = #imageLiteral(resourceName: "statusIcon") // invisible on dark xcode source theme
        icon.isTemplate = true // best for dark mode
        self.statusItem.image = icon

        let menu = self.statusMenu!

        let items: [StatusItemDescriptor] = [
            (0, "cutbox_menu_search_cutbox".l7n, nil, "searchClicked:"),
            (1, "---", nil, nil),
            (2, "cutbox_menu_fuzzy_match".l7n, "fuzzyMatch", "searchModeSelect:"),
            (3, "cutbox_menu_regexp_any_case".l7n, "regexpAnyCase", "searchModeSelect:"),
            (4, "cutbox_menu_regexp_case_match".l7n, "regexpStrictCase", "searchModeSelect:"),
            (5, "---", nil, nil),
            (6, "cutbox_menu_compactui".l7n, nil, "useCompactUIClicked:"),
            (7, "cutbox_menu_hide_preview".l7n, nil, "hidePreviewClicked:"),
            (8, "---", nil, nil),
            (9, "cutbox_menu_preferences".l7n, nil, "openPreferences:"),
            (10, "cutbox_menu_clear_history".l7n, nil, "clearHistoryClicked:"),
            (11, "---", nil, nil),
            (12, "preferences_javascript_transform_reload".l7n, nil, "reloadJavascript:"),
            (13, "preferences_color_theme_reload_themes".l7n, nil, "reloadThemes:"),
            (14, "---", nil, nil),
            // 15: Sparkle: Check for Updates
            //     It will find and fill the empty slot automatically.
            (16, "cutbox_menu_about".l7n, nil, "openAboutPanel:"),
            (17, "cutbox_menu_quit".l7n, nil, "quitClicked:")
            //     So number all the indexes correctly, leaving a gap.
        ]

        items.forEach { addMenuItems(menu: menu, descriptor: $0) }

        self.statusItem.menu = menu

        setModeSelectors(fuzzyMatchModeItem: menu.item(at: 2)!,
                         regexpModeItem: menu.item(at: 3)!,
                         regexpCaseSensitiveModeItem: menu.item(at: 4)!)

        self.useCompactUI = menu.item(at: 6)!
        self.hidePreview = menu.item(at: 7)!

        setCompactUIMenuItem()
        setHidePreviewMenuItem()
    }

    func addMenuItems(menu: NSMenu, descriptor: StatusItemDescriptor) {
        let title = descriptor.1
        if title == "---" {
            menu.insertItem(NSMenuItem.separator(), at: descriptor.0)
        } else {
            let axID = descriptor.2
            let action = Selector(descriptor.3!)
            let item: NSMenuItem = NSMenuItem(title: title,
                                              action: action,
                                              keyEquivalent: "")

            item.target = self

            if axID != nil {
                item.setAccessibilityIdentifier(axID)
            }

            menu.insertItem(item, at: descriptor.0)
        }
    }

    func setHotKeyServiceEventBindings() {
        self.hotKeyService
            .events
            .subscribe(onNext: { event in
                switch event {
                case .search:
                    self.searchViewController.togglePopup()
                }
            })
            .disposed(by: disposeBag)
    }

    func setSearchEventBindings() {
        self.searchViewController
            .events
            .asObservable()
            .subscribe(onNext: { event in
                switch event {
                case .openPreferences:
                    self.preferencesController.open()
                case .toggleSearchMode:
                    self.checkSearchModeItem()
                case .setSearchMode(let mode):
                    self.checkSearchModeItem(mode.axID())
                case .clearHistory:
                    self.clearHistoryClicked(nil)
                case .selectJavascriptFunction:
                    if  !JSFuncService.shared.isEmpty {
                        self.openJavascriptPopup()
                    }
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
                case .hidePreviewSettingChanged(let isOn):
                    self.hidePreview.state = isOn ? .on : .off
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

    func setHidePreviewMenuItem() {
        self.hidePreview.title = "preferences_hide_preview".l7n
        self.hidePreview.state = self.prefs.hidePreview ? .on : .off
    }

    func setModeSelectors(fuzzyMatchModeItem: NSMenuItem,
                          regexpModeItem: NSMenuItem,
                          regexpCaseSensitiveModeItem: NSMenuItem) {
        self.fuzzyMatchModeItem = fuzzyMatchModeItem
        self.regexpModeItem = regexpModeItem
        self.regexpCaseSensitiveModeItem = regexpCaseSensitiveModeItem

        self.searchModeSelectors = [
            self.fuzzyMatchModeItem,
            self.regexpModeItem,
            self.regexpCaseSensitiveModeItem]

        self.searchModeSelectorsDict = [
            "fuzzyMatch": self.fuzzyMatchModeItem,
            "regexpAnyCase": self.regexpModeItem,
            "regexpStrictCase": self.regexpCaseSensitiveModeItem
        ]

        checkSearchModeItem(
            HistoryService
                .shared
                .searchMode
                .axID()
        )
    }

    func searchModeSelectAxID(_ axID: String) {
        let mode = HistorySearchMode.searchMode(from: axID)
        self.searchViewController.events.onNext(.setSearchMode(mode))
    }

    func checkSearchModeItem() {
        let axID = historyService.searchMode.axID()
        self.searchModeSelectors?.forEach { $0.state = .off }
        self.searchModeSelectorsDict?[axID]?.state = .on
    }

    func checkSearchModeItem(_ axID: String) {
        self.searchModeSelectors?.forEach { $0.state = .off }
        self.searchModeSelectorsDict?[axID]?.state = .on
    }
}
