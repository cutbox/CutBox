//
//  PreferencesGeneralView+ShowHiddenDialogButton.swift
//  CutBoxUnitTests
//
//  Created by jason on 28/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class PreferencesGeneralView_ShowHiddenDialogButtonSpec: QuickSpec {
    override func spec() {
        describe("PreferencesGeneralView+ShowHiddenDialogButton") {

            class MockPrefs: CutBoxPreferencesService {
                var resetSuppressedDialogBoxesCalled = false
                @objc override func resetSuppressedDialogBoxes() {
                    resetSuppressedDialogBoxesCalled = true
                }
            }

            it("requests reset of hidden dialogs on tap") {
                let subject = PreferencesGeneralView()
                let prefs = MockPrefs()
                let button = CutBoxBaseButton(frame: .zero)

                subject.prefs = prefs
                subject.showAllHiddenDialogBoxesButton = button
                subject.setupShowAllHiddenDialogBoxesButton()

                subject.showAllHiddenDialogBoxesButton.performClick(NSObject())
                expect(prefs.resetSuppressedDialogBoxesCalled).to(beTrue())
            }
        }
    }
}
