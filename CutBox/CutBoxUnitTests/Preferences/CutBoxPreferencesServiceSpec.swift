//
//  CutBoxPreferencesServiceSpec.swift
//  CutBoxUnitTests
//
//  Created by Jason Milkins on 23/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import RxSwift

class CutBoxPreferencesServiceSpec: QuickSpec {
    override func spec() {
        let mockedDefaults: UserDefaults = UserDefaultsMock()
        let subject = CutBoxPreferencesService(defaults: mockedDefaults)

        describe("CutBoxPreferencesServiceSpec") {

            let bundledThemes = subject.themes
                .map { $0.name }
                .filter { !$0.contains("*") } // Filter out user themes

            it("initializes with bundled themes") {
                expect(bundledThemes.count) == 12
                expect(bundledThemes) == [
                    "Standard",
                    "Skylight",
                    "Sandy Beach",
                    "Darktooth",
                    "Creamsody",
                    "Purplehaze",
                    "Verdant",
                    "Amber Cathode",
                    "macOS",
                    "macOS Graphite",
                    "Standard Dark",
                    "Darkness"
                ]
            }

            it("stores the theme index and name in defaults") {
                expect(mockedDefaults.integer(forKey: "theme")) == 0
                subject.theme = 2
                expect(mockedDefaults.integer(forKey: "theme")) == 2
                expect(mockedDefaults.string(forKey: "themeName")) == "Sandy Beach"
            }
        }

        describe("loadJavaScript") {
            it("loads javascript") {
                class MockJSFuncService: JSFuncService {
                    var reloadCalled = 0
                    override func reload() {
                        reloadCalled += 1
                    }
                }

                let mockJSFuncService = MockJSFuncService()
                subject.js = mockJSFuncService
                subject.loadJavascript()
                expect(mockJSFuncService.reloadCalled) == 1
            }
        }

        describe("savedTimeFilerValue") {
            it("saves to defaults") {
                subject.savedTimeFilterValue = "10 min"
                let value = mockedDefaults.string(forKey: Constants.kSavedTimeFilterValue)
                expect(value) == "10 min"
            }

            it("reads from defaults") {
                mockedDefaults.set("23 min", forKey: Constants.kSavedTimeFilterValue)
                expect(subject.savedTimeFilterValue) == "23 min"
            }
        }

        describe("useCompactUI") {
            it("saves to defaults") {
                subject.useCompactUI = true
                let value = mockedDefaults.bool(forKey: Constants.kUseCompactUI)
                expect(value) == true
            }

            it("reads from defaults") {
                mockedDefaults.set(true, forKey: Constants.kUseCompactUI)
                expect(subject.useCompactUI).to(beTrue())
            }
        }

        describe("hidePreview") {
            it("saves to defaults") {
                subject.hidePreview = true
                let value = mockedDefaults.bool(forKey: Constants.kHidePreview)
                expect(value) == true
            }

            it("reads from defaults") {
                mockedDefaults.set(true, forKey: Constants.kHidePreview)
                expect(subject.hidePreview).to(beTrue())
            }
        }
    }
}
