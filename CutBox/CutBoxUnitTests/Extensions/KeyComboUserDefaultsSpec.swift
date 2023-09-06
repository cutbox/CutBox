//
//  KeyComboUserDefaultsSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 6/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Magnet
import Carbon.HIToolbox

import Quick
import Nimble

class KeyComboUserDefaultsSpec: QuickSpec {
    override func spec() {
        describe("KeyCombo UserDefaults") {
            var userDefaultsMock: UserDefaults!

            beforeEach {
                userDefaultsMock = UserDefaultsMock()
            }

            it("should save and load KeyCombo from UserDefaults") {
                let keyComboToSave = KeyCombo(QWERTYKeyCode: kVK_ANSI_V, cocoaModifiers: [.shift, .command])!
                keyComboToSave.saveUserDefaults(
                    identifier: "keyCombo",
                    defaults: userDefaultsMock)

                let loadedKeyCombo = KeyCombo.loadUserDefaults(
                    identifier: "keyCombo",
                    defaults: userDefaultsMock)

                expect(loadedKeyCombo) == keyComboToSave
            }

            it("should return nil when loading non-existent KeyCombo") {
                let initialData = userDefaultsMock.data(forKey: "keyCombo")
                expect(initialData).to(beNil())

                let loadedKeyCombo = KeyCombo.loadUserDefaults(
                    identifier: "keyCombo",
                    defaults: userDefaultsMock)

                expect(loadedKeyCombo).to(beNil())
            }
        }
    }
}
