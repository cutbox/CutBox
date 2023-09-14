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
    @IBOutlet weak var statusMenu: CutBoxBaseMenu!
    var statusItem: NSStatusItem = cutBoxGetStatusItem()
    var useCompactUI: CutBoxBaseMenuItem!
    var hidePreview: CutBoxBaseMenuItem!
    var searchModeSelectorsDict: [String: CutBoxBaseMenuItem]?
    var searchViewController: SearchViewController
    var jsFuncSearchViewController: JSFuncSearchViewController
    var preferencesController: PreferencesTabViewController
    var aboutPanel: AboutPanel = AboutPanel.fromNib()!
    var hotKeyService = HotKeyService.shared
    var prefs = CutBoxPreferencesService.shared
    var historyService = HistoryService.shared
    var disposeBag = DisposeBag()
    var dialogFactory = DialogFactory()
    var nsAppProvider = CutBoxNSAppProvider()

    @objc func searchClicked(_ sender: CutBoxBaseMenuItem) {
        self.searchViewController.togglePopup()
    }

    @objc func clearHistoryClicked(_ sender: CutBoxBaseMenuItem?) {
        if dialogFactory.suppressibleConfirmationDialog(
            messageText: "confirm_warning_clear_history_title".l7n,
            informativeText: "confirm_warning_clear_history".l7n,
            dialogName: .clearHistoryWarning) {
            self.searchViewController.historyService.clear()
        }
    }

    @objc func openPreferences(_ sender: CutBoxBaseMenuItem) {
        NSApplication.shared.activate(ignoringOtherApps: true)
        preferencesController.open()
    }

    @objc func openAboutPanel(_ sender: CutBoxBaseMenuItem) {
        aboutPanel.makeKeyAndOrderFront(self)
        aboutPanel.center()
    }

    @objc func quitClicked(_ sender: CutBoxBaseMenuItem) {
        nsAppProvider.terminate(sender)
    }

    @objc func useCompactUIClicked(_ sender: CutBoxBaseMenuItem) {
        self.prefs.useCompactUI.toggle()
    }

    @objc func hidePreviewClicked(_ sender: CutBoxBaseMenuItem) {
        self.prefs.hidePreview.toggle()
    }

    @objc func searchModeSelect(_ sender: CutBoxBaseMenuItem) {
        searchModeSelectAxID(sender.accessibilityIdentifier())
    }

    @objc func reloadJavascript(_ sender: CutBoxBaseMenuItem) {
        self.prefs.loadJavascript()
    }

    @objc func reloadThemes(_ sender: CutBoxBaseMenuItem) {
        self.prefs.loadThemes()
    }

    override init() {
        self.searchViewController = SearchViewController()
        self.jsFuncSearchViewController = JSFuncSearchViewController()
        self.preferencesController = PreferencesTabViewController()
        super.init()
    }

    override func awakeFromNib() {
        self.setup()
    }

    func setup() {
        self.hotKeyService.configure()
        self.setMenuItems()
        self.setupEventBindings()
    }
}

extension CutBoxController {
    var statusMenuItems: [StatusItemDescriptor] {
        [
            (0, "cutbox_menu_search_cutbox".l7n, nil, "searchClicked:"),
            (1, "---", nil, nil),
            (2, "cutbox_menu_fuzzy_match".l7n, "fuzzyMatch", "searchModeSelect:"),
            (3, "cutbox_menu_regexp_any_case_match".l7n, "regexpAnyCase", "searchModeSelect:"),
            (4, "cutbox_menu_regexp_case_match".l7n, "regexpStrictCase", "searchModeSelect:"),
            (5, "cutbox_menu_substring_match".l7n, "substringMatch", "searchModeSelect:"),
            (6, "---", nil, nil),
            (7, "cutbox_menu_compactui".l7n, nil, "useCompactUIClicked:"),
            (8, "cutbox_menu_hide_preview".l7n, nil, "hidePreviewClicked:"),
            (9, "---", nil, nil),
            (10, "cutbox_menu_preferences".l7n, nil, "openPreferences:"),
            (11, "cutbox_menu_clear_history".l7n, nil, "clearHistoryClicked:"),
            (12, "---", nil, nil),
            (13, "preferences_javascript_transform_reload".l7n, nil, "reloadJavascript:"),
            (14, "preferences_color_theme_reload_themes".l7n, nil, "reloadThemes:"),
            (15, "---", nil, nil),

            // 16: Sparkle: Check for Updates
            //     It will find and fill the empty slot automatically.

            (17, "cutbox_menu_about".l7n, nil, "openAboutPanel:"),
            (18, "cutbox_menu_quit".l7n, nil, "quitClicked:")
            //     So number all the indexes correctly, leaving a gap.
        ]
    }

    func setMenuItems() {
        let menu = self.statusMenu!
        self.statusItem.menu = menu

        let icon = CutBoxImageRef.statusIcon.image(with: "")
        icon.isTemplate = true // best for dark mode
        self.statusItem.button?.image = icon
        self.statusMenuItems.forEach { addMenuItems(menu: menu, descriptor: $0) }
        self.statusItem.menu = menu

        setModeSelectors(menu.items)

        self.useCompactUI = menu.item(at: 7)!
        self.hidePreview = menu.item(at: 8)!

        setCompactUIMenuItem()
        setHidePreviewMenuItem()
    }

    func addMenuItems(menu: CutBoxBaseMenu, descriptor: StatusItemDescriptor) {
        let title = descriptor.1
        let index = descriptor.0

        if title == "---" {
            menu.insertItem(CutBoxBaseMenuItem.separator(), at: index)
        } else {
            let axID = descriptor.2
            let action = Selector(descriptor.3!)

            let item: CutBoxBaseMenuItem = CutBoxBaseMenuItem(
                title: title,
                action: action,
                keyEquivalent: "")

            item.target = self
            if axID != nil {
                item.setAccessibilityIdentifier(axID)
            }
            menu.insertItem(item, at: index)
        }
    }
}

extension CutBoxController {
    func setupEventBindings() {
        self.setHotKeyServiceEventBindings()
        self.setSearchEventBindings()
        self.setPreferencesEventBindings()
    }

    func setHotKeyServiceEventBindings() {
        self.hotKeyService.events
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }

    func setSearchEventBindings() {
        self.searchViewController.events
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }

    func setPreferencesEventBindings() {
        self.prefs.events
            .subscribe(onNext: onNext)
            .disposed(by: disposeBag)
    }
}

extension CutBoxController {
    func onNext(event: HotKeyEvents) {
        switch event {
        case .search:
            self.searchViewController.togglePopup()
        }
    }

    func onNext(event: SearchViewEvents) {
        switch event {
        case .openPreferences:
            self.preferencesController.open()
        case .toggleSearchMode:
            self.checkSearchModeItem()
        case .setSearchMode(let mode):
            self.checkSearchModeItem(mode.rawValue)
        case .clearHistory:
            self.clearHistoryClicked(nil)
        case .selectJavascriptFunction:
            if  self.jsFuncSearchViewController.hasFuncs {
                self.openJavascriptPopup()
            }
        default:
            break
        }
    }

    func onNext(event: CutBoxPreferencesEvent) {
        switch event {
        case .javascriptReloaded:
            break
        case .historyLimitChanged(let limit):
            self.historyService.historyLimit = limit
        case .compactUISettingChanged(let isOn):
            self.useCompactUI.state = isOn ? .on : .off
        case .hidePreviewSettingChanged(let isOn):
            self.hidePreview.state = isOn ? .on : .off
        case .historyClearByOffset(let offset):
            self.clearHistoryByTimeOffset(offset: offset)
        default:
            break
        }
    }
}

extension CutBoxController {
    func clearHistoryByTimeOffset(offset: TimeInterval) {
        self.historyService.clearHistoryByTimeOffset(offset: offset)
    }
}

extension CutBoxController {
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
}

extension CutBoxController {
    func setCompactUIMenuItem() {
        self.useCompactUI.title = "preferences_use_compact_ui".l7n
        self.useCompactUI.state = self.prefs.useCompactUI ? .on : .off
    }

    func setHidePreviewMenuItem() {
        self.hidePreview.title = "preferences_hide_preview".l7n
        self.hidePreview.state = self.prefs.hidePreview ? .on : .off
    }
}

extension CutBoxController {
    func setModeSelectors(_ items: [NSMenuItem]) {
        self.searchModeSelectorsDict = Dictionary(
            uniqueKeysWithValues: HistorySearchMode
                .allCases.map { $0.rawValue }
                .map { ($0, items.find(axID: $0)) })

        checkSearchModeItem(
            HistoryService
                .shared.searchMode.rawValue
        )
    }

    func searchModeSelectAxID(_ axID: String) {
        let mode = HistorySearchMode.searchMode(from: axID)
        self.searchViewController.events.onNext(.setSearchMode(mode))
    }

    func checkSearchModeItem() {
        let rawValue = historyService.searchMode.rawValue
        self.searchModeSelectorsDict?.values.forEach { $0.state = .off }
        self.searchModeSelectorsDict?[rawValue]?.state = .on
    }

    func checkSearchModeItem(_ axID: String) {
        self.searchModeSelectorsDict?.values.forEach { $0.state = .off }
        self.searchModeSelectorsDict?[axID]?.state = .on
    }
}
