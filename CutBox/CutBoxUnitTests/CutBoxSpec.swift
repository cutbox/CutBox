//
//  File.swift
//  CutBoxUnitTests
//
//  Created by jason on 23/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import Magnet

class CutBoxSpec: QuickSpec {
    override func spec() {
        class MockCutBoxPreferencesService: CutBoxPreferencesService {
            var loadJavascriptWasCalled = false

            override func loadJavascript() {
                loadJavascriptWasCalled = true
            }
        }

        describe("AppDelegate") {
            it("should load javascript when applicationDidFinishLaunching") {
                let subject = AppDelegate()
                let mockPrefs = MockCutBoxPreferencesService()
                subject.prefs = mockPrefs
                subject.applicationDidFinishLaunching(Notification(name: .NSCalendarDayChanged))
                expect(mockPrefs.loadJavascriptWasCalled).to(beTrue())
            }

            it("should unregister hotkeys when applicationWillTerminate") {
                let subject = AppDelegate()
                expect {
                    subject.applicationWillTerminate(Notification(name: .NSCalendarDayChanged))
                }.toNot(throwAssertion())
            }
        }
    }
}
