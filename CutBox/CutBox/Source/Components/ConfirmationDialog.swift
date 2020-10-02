//
//  ConfirmationDialog.swift
//  CutBox
//
//  Created by Jason Milkins on 15/4/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Cocoa

private func makeDialog(messageText: String,
                        informativeText: String,
                        ok: String, cancel: String) -> NSAlert {
    let alert = NSAlert()
    alert.messageText = messageText
    alert.informativeText = informativeText
    alert.addButton(withTitle: ok)
    alert.addButton(withTitle: cancel)

    return alert
}

func suppressibleConfirmationDialog(messageText: String,
                                    informativeText: String,
                                    dialogName: String,
                                    ok: String = "ok".l7n,
                                    cancel: String = "cancel".l7n,
                                    defaults: UserDefaults = UserDefaults.standard) -> Bool {

    let suppressionKey = "\(dialogName)_CutBoxSuppressed"
    let suppressionChoiceKey = "\(dialogName)_CutBoxSuppressedChoice"

    if defaults.bool(forKey: suppressionKey) {
        return defaults.bool(forKey: suppressionChoiceKey)
    }

    let alert = makeDialog(messageText: messageText,
                           informativeText: informativeText,
                           ok: ok, cancel: cancel)

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
