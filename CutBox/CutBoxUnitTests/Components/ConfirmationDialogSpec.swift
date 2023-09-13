//
//  ConfirmationDialogSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 3/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation
import Quick
import Nimble

class FakeNSButton: NSButton {
    var fakeState: NSControl.StateValue = .on

    override var state: NSControl.StateValue {
        get { return fakeState }
        set { fakeState = newValue }
    }
}

class StubbedDialogAlert: DialogAlert {
    override func runModal() -> NSApplication.ModalResponse {
        return .alertFirstButtonReturn
    }

    let fakeSuppressionButton: FakeNSButton = FakeNSButton()

    override var suppressionButton: NSButton? {
        return fakeSuppressionButton
    }
}

class ConfirmationDialogSpec: QuickSpec {
    override func spec() {
        describe("ConfirmationDialog") {
            describe("suppressibleConfirmationDialog") {
                var mockedDefaults: UserDefaultsMock!
                var stubbedAlert: StubbedDialogAlert!
                var dialogName: SuppressibleDialog!
                var dialogFactory: DialogFactory!

                beforeEach {
                    mockedDefaults = UserDefaultsMock()
                    stubbedAlert = StubbedDialogAlert()
                    dialogFactory = DialogFactory()
                    dialogName = .clearHistoryActionClicked
                }

                it("wraps an alert, configures it, returns true when the alertFirstButton is clicked") {
                    let result = dialogFactory.suppressibleConfirmationDialog(
                        messageText: "Message",
                        informativeText: "Very informative it is too",
                        dialogName: dialogName,
                        defaults: mockedDefaults,
                        alert: stubbedAlert)

                    expect(result) == true // stubbedAlert clicked alertFirstButton

                    // Check the alert was styled
                    expect(stubbedAlert.messageText) == "Message"
                    expect(stubbedAlert.informativeText) == "Very informative it is too"
                }

                it("modifies preferences for suppression of the dialog") {
                    expect( mockedDefaults.bool(forKey: dialogName.defaultSuppressionKey) ) == false
                    expect( mockedDefaults.bool(forKey: dialogName.defaultChoiceKey) ) == false

                    _ = dialogFactory.suppressibleConfirmationDialog(
                        messageText: "",
                        informativeText: "",
                        dialogName: dialogName,
                        defaults: mockedDefaults,
                        alert: stubbedAlert
                    )

                    expect( mockedDefaults.bool(forKey: dialogName.defaultSuppressionKey) ) == true
                    expect( mockedDefaults.bool(forKey: dialogName.defaultChoiceKey) ) == true
                }

                it("repeats same user choice after dialog suppression Cancel") {
                    // suppress dialog display
                    mockedDefaults.set(true, forKey: dialogName.defaultSuppressionKey)
                    // automatic user choice: cancel
                    mockedDefaults.set(false, forKey: dialogName.defaultChoiceKey)

                    let result = dialogFactory.suppressibleConfirmationDialog(
                        messageText: "",
                        informativeText: "",
                        dialogName: dialogName,
                        defaults: mockedDefaults,
                        alert: stubbedAlert
                    )

                    expect(result) == false
                }

                it("repeats user choice after dialog suppression OK)") {
                    // suppress dialog display
                    mockedDefaults.set(true, forKey: dialogName.defaultSuppressionKey)
                    // automatic user choice: cancel
                    mockedDefaults.set(true, forKey: dialogName.defaultChoiceKey)

                    let result = dialogFactory.suppressibleConfirmationDialog(
                        messageText: "",
                        informativeText: "",
                        dialogName: dialogName,
                        defaults: mockedDefaults,
                        alert: stubbedAlert
                    )

                    expect(result) == true
                }
            }
        }
    }
}
