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

            it("should return nil when loading non-existent defaults entry") {
                let loadedKeyCombo = KeyCombo.loadUserDefaults(
                    identifier: "foobar",
                    defaults: userDefaultsMock)

                expect(loadedKeyCombo).to(beNil())
            }

            it("should return nil when loading defaults entry that is not an archived KeyCombo") {
                let data = "Test data".data(using: .utf8)
                let archived = NSKeyedArchiver
                    .archivedData(withRootObject: data)
                userDefaultsMock.set(archived, forKey: "barfoo")

                let loadedKeyCombo = KeyCombo.loadUserDefaults(
                    identifier: "barfoo",
                    defaults: userDefaultsMock)

                expect(loadedKeyCombo).to(beNil())
            }
        }
    }
}
