//
//  CutBoxController.swift
//  CutBox
//
//  Created by Jason Milkins on 17/3/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa

import RxSwift

typealias StatusItemDescriptor = (Int, String, String?, String?)

class CutBoxController: NSObject {

    var useCompactUI: NSMenuItem!
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
            (7, "---", nil, nil),
            (8, "cutbox_menu_preferences".l7n, nil, "openPreferences:"),
            (9, "cutbox_menu_clear_history".l7n, nil, "clearHistoryClicked:"),
            (10, "---", nil, nil),
            (11, "preferences_javascript_transform_reload".l7n, nil, "reloadJavascript:"),
            (12, "preferences_color_theme_reload_themes".l7n, nil, "reloadThemes:"),
            (13, "---", nil, nil),
            // 14: Sparkle: Check for Updates
            //     It will find and fill the empty slot automatically.
            (15, "cutbox_menu_about".l7n, nil, "openAboutPanel:"),
            (16, "cutbox_menu_quit".l7n, nil, "quitClicked:")
            //     So number all the indexes correctly, leaving a gap.
        ]

        items.forEach { addMenuItems(menu: menu, descriptor: $0) }

        self.statusItem.menu = menu

        setModeSelectors(fuzzyMatchModeItem: menu.item(at: 2)!,
                         regexpModeItem: menu.item(at: 3)!,
                         regexpCaseSensitiveModeItem: menu.item(at: 4)!)

        self.useCompactUI = menu.item(at: 6)!

        setCompactUIMenuItem()
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
                case .toggleSearchMode:
                    self.checkSearchModeItem()
                case .setSearchMode(let mode):
                    self.checkSearchModeItem(mode.axID())
                case .clearHistory:
                    self.clearHistoryClicked(nil)
                case .selectJavascriptFunction:
                    if  JSFuncService.shared.isEmpty {
                        // do nothing
                    } else {
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
