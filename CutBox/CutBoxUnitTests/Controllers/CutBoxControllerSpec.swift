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

    override func spec() {
        var subject: CutBoxController!
        var mockSearchViewController: MockSearchViewController!
        var mockHistoryService: HistoryService!
        var mockPreferencesService: CutBoxPreferencesService!
        var mockUserDefaults: UserDefaultsMock!
        describe("CutBoxController") {
            beforeEach {
                mockUserDefaults = UserDefaultsMock()
                mockPreferencesService = CutBoxPreferencesService(defaults: mockUserDefaults)
                mockHistoryService = HistoryService(defaults: mockUserDefaults, prefs: mockPreferencesService)
                mockSearchViewController = MockSearchViewController(pasteboardService: mockHistoryService)

                subject = CutBoxController()
                subject.prefs = mockPreferencesService
                subject.searchViewController = mockSearchViewController
            }

            context("HotKey") {

                it("should have a hotKeyService") {
                    expect(subject.hotKeyService).to(beAnInstanceOf(HotKeyService.self))
                }

                it("should handle hotKeyService events") {
                    subject.onNext(event: HotKeyEvents.search)
                    expect(mockSearchViewController.togglePopupWasCalled).to(beTrue())
                }
            }
        }
    }
}
