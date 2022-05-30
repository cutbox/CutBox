//
//  PreferencesWindowSpec.swift
//  CutBoxTests
//
//  Created by Jason on 15/4/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import Quick
import Nimble

class PreferencesWindowSpec: QuickSpec {

    override func spec() {
        describe("PreferencesWindow") {
            describe("limitChangeIsDestructive") {
                let subject: PreferencesAdvancedView = PreferencesAdvancedView.fromNib()!
                it("returns true when limit change is less than current limit") {
                    expect(subject
                        .limitChangeIsDestructive(limit: 10,
                                                  currentLimit: 100))
                        .to(beTrue())
                }

                it("returns false if the new limit is 0") {
                    expect(subject
                        .limitChangeIsDestructive(limit: 0,
                                                  currentLimit: 100))
                        .to(beFalse())
                }

                it("returns false when the new limit is greater then the current limit") {
                    expect(subject
                        .limitChangeIsDestructive(limit: 101,
                                                  currentLimit: 100))
                        .to(beFalse())
                }

                it("returns false when the new limit is equal to the current limit") {
                    expect(subject
                        .limitChangeIsDestructive(limit: 100,
                                                  currentLimit: 100))
                        .to(beFalse())
                }
            }
        }
    }
}
