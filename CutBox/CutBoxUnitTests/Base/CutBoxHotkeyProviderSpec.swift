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
        describe("HotKeyService") {
            let provider = CutBoxHotkeyProvider()
            let subject = HotKeyService(hotkeyProvider: provider)

            beforeEach {
                provider.testing = true
            }

            it("should configure a default key combo") {
                subject.configure()
                expect(provider.createWasCalled).to(beTrue())
            }

            it("should reset default key combo") {
                subject.resetDefaultGlobalToggle()
                expect(provider.createWasCalled).to(beTrue())
            }

            it("should search") {
                var result: HotKeyEvents?
                _ = subject.events.bind(onNext: { result = $0 })
                subject.search(NSObject())

                expect(result) == HotKeyEvents.search
            }
        }

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
