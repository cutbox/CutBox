//
//  CutBoxHotkeyProviderSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 12/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import Magnet
import Carbon

class CutBoxHotkeyProviderSpec: QuickSpec {
    @objc public func noopSelector() {}

    override func spec() {
        describe("CutBoxHotkeyProvider") {
            describe("create") {
                context("test mode") {
                    it("should return nil ") {
                        let keyCombo = KeyCombo(QWERTYKeyCode: kVK_ANSI_V,
                                                      cocoaModifiers: [.shift, .command])!
                        let provider = CutBoxHotkeyProvider()
                        provider.testing = true
                        let combo = provider.create(identifier: "Noop",
                                                    keyCombo: keyCombo,
                                                    target: self,
                                                    action: #selector(self.noopSelector))
                        expect(combo).to(beNil())
                        expect(provider.createWasCalled).to(beTrue())
                    }

                    it("should return a valid object") {
                        let keyCombo = KeyCombo(QWERTYKeyCode: kVK_ANSI_V,
                                                cocoaModifiers: [.shift, .command])!
                        let provider = CutBoxHotkeyProvider()
                        provider.testing = false
                        let combo = provider.create(identifier: "Noop",
                                                    keyCombo: keyCombo,
                                                    target: self,
                                                    action: #selector(self.noopSelector))
                        expect(combo).to(beAnInstanceOf(HotKey.self))
                    }
                }
            }
        }
    }
}
