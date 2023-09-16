//
//  CutBoxPreferencesService+ResetSuppressedDialogBoxesSpec.swift
//  CutBoxUnitTests
//
//  Created by Jason Milkins on 3/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class CutBoxPreferencesService_ResetSuppressedDialogBoxesSpec: QuickSpec {
    override func spec() {
        let mockDefaults = UserDefaultsMock()
        let subject = CutBoxPreferencesService(defaults: mockDefaults)

        beforeEach {
            SuppressibleDialog.all.forEach {
                mockDefaults.set(true, forKey: "\($0)_CutBoxSuppressed")
                mockDefaults.set(true, forKey: "\($0)_CutBoxSuppressedChoice")
            }
        }

        describe("CutBoxPreferencesService+ResetSuppressedDialogBoxesSpec") {
            it("resets the settings for dialog box suppression") {
                let before = mockDefaults.store
                    .filter { $0.key.contains("_CutBoxSuppressed") }
                    .count

                subject.resetSuppressedDialogBoxes()

                let after = mockDefaults.store
                    .filter { $0.key.contains("_CutBoxSuppressed") }
                    .count

                expect(before) == 6
                expect(after) == 0
            }
        }
    }
}
