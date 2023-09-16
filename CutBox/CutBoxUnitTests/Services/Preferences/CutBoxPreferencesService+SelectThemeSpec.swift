//
//  CutBoxPreferencesService+SelectThemeSpec.swift
//  CutBoxUnitTests
//
//  Created by Jason Milkins on 22/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import RxSwift

class CutBoxPreferencesService_SelectThemeSpec: QuickSpec {
    override func spec() {
        var subject: CutBoxPreferencesService!
        let mockDefaults = UserDefaultsMock()

        beforeEach {
            subject = CutBoxPreferencesService(defaults: mockDefaults)
        }

        describe("CutBoxPreferencesService+SelectTheme") {

            context("themeName/theme set in defaults") {
                context("valid settings") {
                    it("returns preferred theme") {
                        mockDefaults.set("Standard Dark", forKey: "themeName")
                        mockDefaults.set(10, forKey: "theme")
                        subject = CutBoxPreferencesService(defaults: mockDefaults)

                        expect(subject.currentTheme.name) == "Standard Dark"
                    }
                }

                context("User themes change or missing") {
                    it("returns default theme: Standard") {
                        mockDefaults.set(75, forKey: "theme")
                        mockDefaults.set("ObviouslyFakeThemeName", forKey: "themeName")
                        subject = CutBoxPreferencesService(defaults: mockDefaults)

                        expect(subject.themeName) == "Standard"
                    }
                }

                context("Theme index in defaults, themeName is undefined") {
                    it("returns theme matching theme index") {
                        mockDefaults.set(3, forKey: "theme")
                        mockDefaults.removeObject(forKey: "themeName")
                        subject = CutBoxPreferencesService(defaults: mockDefaults)

                        expect(subject.currentTheme.name) == "Darktooth"
                    }
                }

                context("Theme name is correct but index is mismatched") {
                    it("returns the preferred theme") {
                        // Note: We don't select theme by int from defaults
                        // since v1.5.8. Instead we use the themeName

                        let themeName = "Standard Dark"
                        mockDefaults.set(themeName, forKey: "themeName")
                        // Standard Dark index is 10
                        // We'll set the wrong index but it shouldn't matter
                        mockDefaults.set(1234, forKey: "theme")

                        subject = CutBoxPreferencesService(defaults: mockDefaults)
                        // We expect the theme to match the name
                        expect(subject.themeName) == themeName
                    }
                }
            }

            it("Has access to a list of themes") {
                expect(subject.themes).to(beAKindOf([CutBoxColorTheme].self))
            }

            it("returns the selected theme int") {
                expect(subject.theme) == 0
            }

            it("returns the selected theme name") {
                expect(subject.themeName) == "Standard"
            }

            it("returns the selected theme") {
                expect(subject.currentTheme).to(beAnInstanceOf(CutBoxColorTheme.self))
            }

            it("cycles through available themes") {
                let count = subject.themes.count
                subject.cycleTheme()
                expect(subject.theme) == 1
                (count - 1).doTimes { subject.cycleTheme() }
                expect(subject.theme) == 0
            }

            it("loads themes") {
                var nextEvent: CutBoxPreferencesEvent?
                let trash = DisposeBag()

                subject.events.bind(onNext: { nextEvent = $0 }).disposed(by: trash)

                subject.loadThemes()
                expect(nextEvent) == .themesReloaded
            }
        }
    }
}
