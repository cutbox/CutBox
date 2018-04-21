//
//  ConfirmationDialog.swift
//  CutBox
//
//  Created by Jason on 15/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

fileprivate func makeDialog(messageText: String,
                            informativeText: String,
                            ok: String, cancel: String,
                            dialogName: String? = nil,
                            showsHelp: Bool = false) -> NSAlert {
    let alert = NSAlert()
    alert.messageText = messageText
    alert.informativeText = informativeText
    alert.addButton(withTitle: ok)
    alert.addButton(withTitle: cancel)

    if showsHelp {
        guard let name = dialogName else {
            fatalError("\(#function) requires a dialogName when showsHelp == true")
        }

        alert.showsHelp = true
        alert.helpAnchor = NSHelpManager.AnchorName(name)
    }

    return alert
}

func suppressibleConfirmationDialog(messageText: String,
                                    informativeText: String,
                                    dialogName: String,
                                    showsHelp: Bool = false,
                                    ok: String = "ok".l7n,
                                    cancel: String = "cancel".l7n,
                                    defaults: UserDefaults = UserDefaults.standard) -> Bool {
    let suppressionKey = "\(dialogName)Suppressed"

    if defaults.bool(forKey: suppressionKey) {
        return true
    }

    let alert = makeDialog(messageText: messageText,
                           informativeText: informativeText,
                           ok: ok, cancel: cancel,
                           dialogName: dialogName,
                           showsHelp: showsHelp)

    alert.showsSuppressionButton = true

    if alert.suppressionButton?.state == .on {
        defaults.set(true, forKey: suppressionKey)
    }

    return alert.runModal() == .alertFirstButtonReturn
}

func confirmationDialog(messageText: String,
                        informativeText: String,
                        dialogName: String?,
                        showsHelp: Bool = false,
                        ok: String = "ok".l7n,
                        cancel: String = "cancel".l7n) -> Bool {

    let alert = makeDialog(messageText: messageText,
                           informativeText: informativeText,
                           ok: ok, cancel: cancel,
                           dialogName: dialogName,
                           showsHelp: showsHelp)

    return alert.runModal() == .alertFirstButtonReturn
}


