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
    }

    class MockStatusMenu: CutBoxBaseMenu {
    }

    override func spec() {
        var subject: CutBoxController!
        var mockSearchViewController: MockSearchViewController!
        var mockHistoryService: HistoryService!
        var mockPreferencesService: CutBoxPreferencesService!
        var mockUserDefaults: UserDefaultsMock!
        var mockPreferencesTabViewController: MockPreferencesTabViewController!
        var mockAboutPanel: MockAboutPanel!
        var mockHotKeyService: MockHotKeyService!
        var mockStatusMenu: MockStatusMenu!

        describe("CutBoxController") {
            beforeEach {
                mockUserDefaults = UserDefaultsMock()
                mockPreferencesService = CutBoxPreferencesService(defaults: mockUserDefaults)
                mockHistoryService = HistoryService(defaults: mockUserDefaults, prefs: mockPreferencesService)
                mockSearchViewController = MockSearchViewController(pasteboardService: mockHistoryService)
                mockPreferencesTabViewController = MockPreferencesTabViewController()
                mockAboutPanel = MockAboutPanel()
                mockHotKeyService = MockHotKeyService(hotkeyProvider: CutBoxHotkeyProvider())
                mockStatusMenu = MockStatusMenu()

                subject = CutBoxController()
                subject.prefs = mockPreferencesService
                subject.searchViewController = mockSearchViewController
                subject.preferencesController = mockPreferencesTabViewController
                subject.aboutPanel = mockAboutPanel
                subject.hotKeyService = mockHotKeyService
                subject.statusMenu = mockStatusMenu
                subject.statusItem = cutBoxGetStatusItem(testing: true)
            }

            context("event bindings") {
                it("binds to cutbox event backbone") {
                    subject.setupEventBindings()

                    expect(subject.hotKeyService.events.hasObservers).to(beTrue())
                    expect(subject.searchViewController.events.hasObservers).to(beTrue())
                    expect(subject.prefs.events.hasObservers).to(beTrue())
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
                        // At runtime an item is added via xib
                        // We'll simulate that it here:
                        subject.statusMenu.addItem(CutBoxBaseMenuItem())

                        // Now the test proper.
                        subject.setMenuItems()
                        expect(subject.statusMenu.items.count) == 19
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
