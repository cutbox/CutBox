//
//  PreferencesAdvancedViewSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 15/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class PreferencesAdvancedViewSpec: QuickSpec {
    override func spec() {
        describe("PreferencesAdvancedView") {
            let mockUserDefaults = UserDefaultsMock()
            let prefs = CutBoxPreferencesService(defaults: mockUserDefaults)
            let subject = PreferencesAdvancedView(frame: .zero)

            beforeEach {
                subject.prefs = prefs

            }

            context("joinStyleSelectorAction") {
                it("should set join style") {
                    let joinStringTextField = CutBoxBaseTextField(frame: .zero)
                    subject.joinStringTextField = joinStringTextField

                    let segmentedContol = CutBoxBaseSegmentedControl()
                    segmentedContol.selectedSegment = 1

                    subject.joinStyleSelectorAction(segmentedContol)
                    expect(joinStringTextField.isHidden).to(beFalse())
                    expect(joinStringTextField.isEnabled).to(beTrue())
                    expect(prefs.useJoinString).to(beTrue())
                }
            }

            context("setHistoryLimitWithConfirmation") {
                let historyLimitTextField = CutBoxBaseTextField(frame: .zero)

                context("when the limit is reduced") {
                    context("and user confirms") {
                        beforeEach {
                            DialogFactory.testing = true
                            DialogFactory.testResponse = true
                            subject.prefs.historyLimit = 1000
                        }
                        it("should set the history limit via a confirmation dialog") {
                            subject.historyLimitTextField = historyLimitTextField
                            subject.setHistoryLimitWithConfirmation(60)
                            expect(subject.prefs.historyLimit) == 60
                        }
                    }
                    
                    context("and user denies") {
                        beforeEach {
                            DialogFactory.testing = true
                            DialogFactory.testResponse = false
                            subject.prefs.historyLimit = 1000
                        }
                        it("should set the history limit via a confirmation dialog") {
                            subject.historyLimitTextField = historyLimitTextField
                            subject.setHistoryLimitWithConfirmation(60)
                            expect(subject.prefs.historyLimit) == 1000
                            expect(subject.historyLimitTextField.stringValue) == "1000"
                        }
                    }
                }
            }
        }
    }
}
