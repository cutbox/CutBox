//
//  ConfirmationDialog.swift
//  CutBox
//
//  Created by Jason Milkins on 15/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

// swiftlint:disable identifier_name

import Cocoa

enum SuppressibleDialog: String, Equatable, CaseIterable {
    case clearHistoryActionClicked
    case destructiveLimitChangeWarning
    case clearHistoryWarning

    var defaultSuppressionKey: String {
        return "\(self)_CutBoxSuppressed"
    }

    var defaultChoiceKey: String {
        return "\(defaultSuppressionKey)Choice"
    }

    static var all: [SuppressibleDialog] {
        return Self.allCases
    }
}

class DialogAlert: NSAlert {}

private func makeDialog(messageText: String,
                        informativeText: String,
                        ok: String,
                        cancel: String,
                        alert: DialogAlert = DialogAlert()) -> DialogAlert {
    alert.messageText = messageText
    alert.informativeText = informativeText
    alert.addButton(withTitle: ok)
    alert.addButton(withTitle: cancel)
    return alert
}

func suppressibleConfirmationDialog(messageText: String,
                                    informativeText: String,
                                    dialogName: SuppressibleDialog,
                                    ok: String = "ok".l7n,
                                    cancel: String = "cancel".l7n,
                                    defaults: UserDefaults = UserDefaults.standard,
                                    alert: DialogAlert = DialogAlert()) -> Bool {

    let suppressionKey = "\(dialogName)_CutBoxSuppressed"
    let suppressionChoiceKey = "\(dialogName)_CutBoxSuppressedChoice"

    if defaults.bool(forKey: suppressionKey) {
        return defaults.bool(forKey: suppressionChoiceKey)
    }

    let alert: DialogAlert = makeDialog(messageText: messageText,
                                        informativeText: informativeText,
                                        ok: ok,
                                        cancel: cancel,
                                        alert: alert)

    alert.showsSuppressionButton = true

    let alertResponse = alert.runModal() == .alertFirstButtonReturn

    if alert.suppressionButton?.state == .on {
        defaults.set(true, forKey: suppressionKey)
        defaults.set(alertResponse, forKey: suppressionChoiceKey)
    }

    return alertResponse
}

func confirmationDialog(messageText: String,
                        informativeText: String,
                        ok: String = "ok".l7n,
                        cancel: String = "cancel".l7n) -> Bool {

    let alert = makeDialog(messageText: messageText,
                           informativeText: informativeText,
                           ok: ok, cancel: cancel)

    return alert.runModal() == .alertFirstButtonReturn
}
