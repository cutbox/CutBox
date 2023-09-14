//
//  CutBoxControllerSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 9/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class CutBoxControllerSpec: QuickSpec {
    class MockSearchViewController: SearchViewController {
        var togglePopupWasCalled: Bool = false
        override func togglePopup() {
            togglePopupWasCalled.toggle()
        }
    }

    class MockJSFuncService: JSFuncService {
        var reloadCalled = false
        override func reload() {
            reloadCalled = true
        }
    }

    class MockJSFuncPopup: PopupController {
        var togglePopupWasCalled = false
        override func togglePopup() {
            togglePopupWasCalled = true
        }
    }

    class MockJSFuncView: JSFuncSearchAndPreviewView {
        var applyThemeWasCalled = false
        override func applyTheme() {
            applyThemeWasCalled = true
        }
    }

    class MockJSFuncSearchViewController: JSFuncSearchViewController {
        var hasFuncsWasCalled = false
        override var hasFuncs: Bool {
            hasFuncsWasCalled = true
            return false
        }
    }

    class MockPreferencesTabViewController: PreferencesTabViewController {
        var openWasCalled = false
        override func open() {
            openWasCalled = true
        }
    }

    class MockAboutPanel: AboutPanel {
        var makeKeyAndOrderFrontWasCalled = false
        var centerWasCalled = false

        override func makeKeyAndOrderFront(_ sender: Any?) {
            makeKeyAndOrderFrontWasCalled = true
        }

        override func center() {
            centerWasCalled = true
        }
    }

    class MockHotKeyService: HotKeyService {
        var configureWasCalled = false
        override func configure() {
            configureWasCalled = true
        }
    }

    class MockHistoryService: HistoryService {
        var clearHistoryByTimeOffsetWasCalledWith: TimeInterval?
        override func clearHistoryByTimeOffset(offset: TimeInterval) {
            clearHistoryByTimeOffsetWasCalledWith = offset
        }
    }

    class MockStatusMenu: CutBoxBaseMenu {
    }

    override func spec() {
        var subject: CutBoxController!
        var mockSearchViewController: MockSearchViewController!
        var mockJSFuncSearchViewController: MockJSFuncSearchViewController!
        var mockHistoryService: MockHistoryService!
        var mockPreferencesService: CutBoxPreferencesService!
        var mockUserDefaults: UserDefaultsMock!
        var mockPreferencesTabViewController: MockPreferencesTabViewController!
        var mockAboutPanel: MockAboutPanel!
        var mockHotKeyService: MockHotKeyService!
        var mockStatusMenu: MockStatusMenu!
        var mockJSFuncView: MockJSFuncView!
        var mockJSFuncPopup: MockJSFuncPopup!
        var mockJSFuncService: MockJSFuncService!

        describe("CutBoxController") {
            beforeEach {
                mockUserDefaults = UserDefaultsMock()
                mockJSFuncService = MockJSFuncService()
                JSFuncService.shared = mockJSFuncService
                mockPreferencesService = CutBoxPreferencesService(defaults: mockUserDefaults)
                mockHistoryService = MockHistoryService(defaults: mockUserDefaults, prefs: mockPreferencesService)
                mockJSFuncView = MockJSFuncView(frame: NSRect(x: 0, y: 0, width: 500, height: 300))
                mockJSFuncPopup = MockJSFuncPopup(content: mockJSFuncView)
                mockJSFuncSearchViewController = MockJSFuncSearchViewController(
                    cutBoxPreferences: mockPreferencesService,
                    jsFuncView: mockJSFuncView)
                mockPreferencesTabViewController = MockPreferencesTabViewController()
                mockAboutPanel = MockAboutPanel()
                mockHotKeyService = MockHotKeyService(hotkeyProvider: CutBoxHotkeyProvider())
                mockStatusMenu = MockStatusMenu()
                mockSearchViewController = MockSearchViewController(pasteboardService: mockHistoryService)

                subject = CutBoxController()
                subject.searchViewController = mockSearchViewController
                subject.jsFuncSearchViewController = mockJSFuncSearchViewController
                subject.preferencesController = mockPreferencesTabViewController

                subject.prefs = mockPreferencesService
                subject.aboutPanel = mockAboutPanel
                subject.hotKeyService = mockHotKeyService
                subject.historyService = mockHistoryService
                subject.statusMenu = mockStatusMenu
                subject.statusItem = cutBoxGetStatusItem(testing: true)
                // simulate menu item added via xib
                subject.statusMenu.addItem(CutBoxBaseMenuItem())
            }

            context("setup") {
                it("should set up, hotkey, menu and event bindings") {
                    expect(subject.statusMenu.items.count) == 1

                    subject.setup()

                    expect(mockHotKeyService.configureWasCalled).to(beTrue())

                    expect(subject.statusMenu.items.count) == 19

                    expect(subject.hotKeyService.events.hasObservers).to(beTrue())
                    expect(subject.searchViewController.events.hasObservers).to(beTrue())
                    expect(subject.prefs.events.hasObservers).to(beTrue())
                }
            }

            context("event bindings") {
                it("binds to cutbox event backbone") {
                    subject.setupEventBindings()

                    expect(subject.hotKeyService.events.hasObservers).to(beTrue())
                    expect(subject.searchViewController.events.hasObservers).to(beTrue())
                    expect(subject.prefs.events.hasObservers).to(beTrue())
                }
            }

            context("openJavascriptPopup") {
                it("should trigger the opening of the Javascript popup") {
                    subject.jsFuncSearchViewController.jsFuncPopup = mockJSFuncPopup
                    subject.jsFuncSearchViewController.jsFuncView = mockJSFuncView

                    subject.openJavascriptPopup()

                    expect(mockJSFuncView.applyThemeWasCalled).to(beTrue())
                    expect(mockJSFuncPopup.togglePopupWasCalled).to(beTrue())
                }
            }

            context("checkSearchModeItem") {
                it("should set the menu item to match the search mode in history service") {
                    subject.setMenuItems()
                    subject.historyService.searchMode = .substringMatch

                    subject.checkSearchModeItem()
                    let result = subject.searchModeSelectorsDict?
                        .first(where: { (_: String, value: CutBoxBaseMenuItem) in
                            value.state == .on
                        })

                    expect(result?.key) == "substringMatch"
                }
            }

            context("status menu actions") {
                context("searchClicked") {
                    it("should toggle search view") {
                        subject.searchClicked(CutBoxBaseMenuItem())
                        expect(mockSearchViewController.togglePopupWasCalled).to(beTrue())
                    }
                }

                context("clearHistory") {
                    it("should call clear history") {
                        var result = false
                        _ = mockHistoryService.events.subscribe(onNext: {
                            if $0 == .didClearHistory {
                                result = true
                            }
                        })

                        DialogFactory.testing = true
                        DialogFactory.testResponse = true
                        subject.clearHistoryClicked(CutBoxBaseMenuItem())
                        expect(result).toEventually(beTrue())
                    }
                }

                context("openPreferences") {
                    it("should open the preferences window") {
                        subject.openPreferences(CutBoxBaseMenuItem())
                        expect(mockPreferencesTabViewController.openWasCalled).to(beTrue())
                    }
                }

                context("openAboutPanel") {
                    it("should open the about panle") {
                        subject.openAboutPanel(CutBoxBaseMenuItem())
                        expect(mockAboutPanel.makeKeyAndOrderFrontWasCalled).to(beTrue())
                    }
                }

                context("quitClicked") {
                    it("should terminate the app") {
                        CutBoxNSAppProvider.testing = true
                        subject.quitClicked(CutBoxBaseMenuItem())
                        expect(subject.nsAppProvider.terminateWasCalled).to(beTrue())
                    }
                }

                context("useCompactUIClicked") {
                    it("should toggle the preference for compact UI") {
                        subject.useCompactUIClicked(CutBoxBaseMenuItem())
                        expect(mockPreferencesService.useCompactUI).to(beTrue())
                        subject.useCompactUIClicked(CutBoxBaseMenuItem())
                        expect(mockPreferencesService.useCompactUI).to(beFalse())
                    }
                }

                context("hidePreviewClicked") {
                    it("should toggle the preference for compact UI") {
                        subject.hidePreviewClicked(CutBoxBaseMenuItem())
                        expect(mockPreferencesService.hidePreview).to(beTrue())
                        subject.hidePreviewClicked(CutBoxBaseMenuItem())
                        expect(mockPreferencesService.hidePreview).to(beFalse())
                    }
                }

                context("searchModeSelect") {
                    it("should set the search mode in preferences and history service") {
                        var result = false
                        _ = mockSearchViewController
                            .events.subscribe(onNext: { (event: SearchViewEvents) in
                                switch event {
                                case .setSearchMode(let mode):
                                    if mode == .substringMatch {
                                        result = true
                                    }
                                default:
                                    break
                                }
                            })

                        let menuItem = CutBoxBaseMenuItem()
                        menuItem.setAccessibilityIdentifier("substringMatch")
                        subject.searchModeSelect(menuItem)
                        expect(result).toEventually(beTrue())
                    }
                }

                context("reloadThemes") {
                    it("should reload themes") {
                        var result = false
                        _ = mockPreferencesService
                            .events.subscribe(onNext: { (event: CutBoxPreferencesEvent) in
                                switch event {
                                case .themesReloaded:
                                    result = true
                                default:
                                    break
                                }
                            })

                        subject.reloadThemes(CutBoxBaseMenuItem())
                        expect(result).toEventually(beTrue())
                    }
                }

                context("reloadJavascript") {
                    it("should reload javascript") {
                        var result = false

                        _ = mockPreferencesService
                            .events.subscribe(onNext: { (event: CutBoxPreferencesEvent) in
                                switch event {
                                case .javascriptReloaded:
                                    result = true
                                default:
                                    break
                                }
                            })

                        subject.reloadJavascript(CutBoxBaseMenuItem())
                        expect(result).toEventually(beTrue())
                    }
                }

                context("status menu setup") {
                    it("menu should have menu items configures") {
                        subject.setMenuItems()
                        expect(subject.statusMenu.items.count) == 19
                    }
                }
            }

            context("onNext") {
                context("SearchViewEvent") {

                    context("openPreferences") {
                        it("should tell preferences controller to open") {
                            subject.onNext(event: .openPreferences)
                            expect(mockPreferencesTabViewController.openWasCalled).to(beTrue())
                        }
                    }

                    context("search mode selection events") {
                        let searchModeIndexes = [1, 2, 3, 4]

                        beforeEach {
                            subject.setMenuItems()
                            // uncheck search mode menu items
                            searchModeIndexes.forEach {
                                subject.statusMenu.item(at: $0)?.state = .off
                            }
                        }

                        context("toggleSearchMode") {
                            it("should update the search mode status menu items") {
                                subject.onNext(event: .toggleSearchMode)
                                let result = searchModeIndexes.map { subject.statusMenu.item(at: $0)?.state }
                                    .map { $0 == .on }
                                    .filter { $0 }
                                    .count

                                expect(result) == 1
                            }
                        }

                        context("setSearchMode(let mode)") {
                            it("should update the search mode status menu items using mode") {
                                let substringMatchMenuItem = subject.searchModeSelectorsDict!["substringMatch"]
                                subject.onNext(event: .setSearchMode(.substringMatch))
                                expect(substringMatchMenuItem?.state) == .on
                            }
                        }
                    }

                    context("clearHistory") {
                        it("should trigger clear history") {
                            DialogFactory.testing = true
                            DialogFactory.testResponse = false
                            subject.onNext(event: .clearHistory)
                            expect(DialogFactory.madeDialog) == "confirm_warning_clear_history_title".l7n
                        }
                    }

                    context("selectJavascriptFunction") {
                        it("should tell JS view to open") {
                            subject.onNext(event: .selectJavascriptFunction)
                            expect(mockJSFuncSearchViewController.hasFuncsWasCalled).to(beTrue())
                        }
                    }
                }

                context("CutBoxPreferencesEvent") {

                    context("historyLimitChanged(limit: Int)") {
                        it("should set the history limit") {
                            subject.onNext(event: .historyLimitChanged(limit: 10))
                            expect(subject.historyService.historyLimit) == 10
                        }
                    }

                    context("compactUISettingChanged(isOn: Bool)") {
                        it("should update the compactUI menu state to reflect the settings change") {
                            subject.useCompactUI = CutBoxBaseMenuItem()
                            subject.onNext(event: .compactUISettingChanged(isOn: true))
                            expect(subject.useCompactUI.state) == .on
                        }
                    }

                    context("hidePreviewSettingChanged(isOn: Bool)") {
                        it("should update the hidePreview menu state to reflect the settings change") {
                            subject.hidePreview = CutBoxBaseMenuItem()
                            subject.onNext(event: .hidePreviewSettingChanged(isOn: true))
                            expect(subject.hidePreview.state) == .on
                        }
                    }

                    context("historyClearByOffset(offset: TimeInterval)") {
                        it("should tell history service to clear") {
                            subject.onNext(event: .historyClearByOffset(offset: 1000))
                            expect(mockHistoryService.clearHistoryByTimeOffsetWasCalledWith) == 1000.0
                        }
                    }
                }
            }
        }

        context("HotKey") {
            it("should have a hotKeyService") {
                expect(subject.hotKeyService).to(beAKindOf(HotKeyService.self))
            }

            it("should handle hotKeyService events") {
                subject.onNext(event: HotKeyEvents.search)
                expect(mockSearchViewController.togglePopupWasCalled).to(beTrue())
            }
        }
    }
}
