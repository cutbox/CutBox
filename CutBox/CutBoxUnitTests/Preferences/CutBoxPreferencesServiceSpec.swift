//
//  CutBoxPreferencesServiceSpec.swift
//  CutBoxUnitTests
//
//  Created by Jason Milkins on 23/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class CutBoxPreferencesServiceSpec: QuickSpec {
    override func spec() {
        describe("CutBoxPreferencesServiceSpec") {
            let defaults: UserDefaults = UserDefaultsMock()
            let subject = CutBoxPreferencesService(defaults: defaults)

            let bundledThemes = subject.themes
                .map { $0.name }
                .filter { !$0.contains("*") } // Filter out user themes

            it("initializes with bundled themes") {
                expect(bundledThemes.count) == 11
                expect(bundledThemes) == [
                    "Darkness",
                    "Skylight",
                    "Sandy Beach",
                    "Darktooth",
                    "Creamsody",
                    "Purplehaze",
                    "Verdant",
                    "Amber Cathode",
                    "macOS",
                    "macOS Graphite",
                    "Standard Dark"
                ]
            }

            it("stores the theme index and name in defaults") {
                expect(defaults.integer(forKey: "theme")) == 0
                subject.theme = 2
                expect(defaults.integer(forKey: "theme")) == 2
                expect(defaults.string(forKey: "themeName")) == "Sandy Beach"
            }
        }
    }
}
