//
//  ConfirmationDialog.swift
//  CutBox
//
//  Created by Jason on 15/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Cocoa

typealias ConfirmAndSuppression = (confirm: Bool, suppression: Bool)

func confirmationDialog(question: String,
                        text: String,
                        ok: String = "OK",
                        cancel: String = "Cancel",
                        suppression: Bool = false) -> ConfirmAndSuppression {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: ok)
    alert.addButton(withTitle: cancel)
    alert.showsSuppressionButton = true
    return (confirm: alert.runModal() == .alertFirstButtonReturn,
            suppression: alert.suppressionButton?.state == .on)
}
