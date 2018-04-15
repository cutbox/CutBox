//
//  PreferencesWindow+HistoryLimit.swift
//  CutBox
//
//  Created by Jason on 14/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxCocoa
import RxSwift

class HistoryLimitNumberFormatter: NumberFormatter {
    override var isPartialStringValidationEnabled: Bool {
        set {}
        get { return true }
    }

    var intOnlyRegex: NSRegularExpression? {
        do {
        return try NSRegularExpression(pattern: "^[0-9]*$",
                                   options: NSRegularExpression.Options.caseInsensitive)
        } catch {
            fatalError("invalid regexp in intOnlyRegex")
        }
    }

    override func isPartialStringValid(_ partialString: String,
                                       newEditingString newString: AutoreleasingUnsafeMutablePointer<NSString?>?,
                                       errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?)
        -> Bool {
            return intOnlyRegex?.matches(in: partialString,
                                         options: .anchored,
                                         range: NSRange(partialString.startIndex...,
                                                        in: partialString)).count == 1
    }
}

extension PreferencesWindow {
    func setupHistoryLimitControls() {
        self.historyLimitTextField.formatter = HistoryLimitNumberFormatter()

        self.historyUnlimitedCheckbox
            .rx
            .state
            .map { $0 == .off }
            .subscribe(onNext:
                { self.prefs.historyLimited = $0 })
            .disposed(by: disposeBag )

        self.historyUnlimitedCheckbox
            .rx
            .state
            .map { $0 == .off }
            .subscribe(onNext: {
                self.historyLimitTextField.isEnabled = $0
                if !$0 { self.historyLimitTextField.stringValue = "" }
            })
            .disposed(by: disposeBag)

        let historyLimit = prefs.historyLimit

        self.historyLimitTextField.stringValue = String(historyLimit)

        self.historyLimitTextField
            .rx
            .controlEvent // end editing
            .subscribe(onNext: {
                let limit = Int(self.historyLimitTextField.stringValue) ?? 0
                self.setHistoryLimitWithConfirmation(limit)
            })
            .disposed(by: disposeBag)

        if prefs.historyLimited {
            self.historyUnlimitedCheckbox.state = .off
        } else {
            self.historyUnlimitedCheckbox.state = .on
        }
    }

    func limitChangeIsDestructive(limit: Int, currentLimit: Int) -> Bool {
        return (limit > 0 && currentLimit == 0) ||
            (limit > 0 && currentLimit > limit)
    }

    func setHistoryLimitWithConfirmation(_ limit: Int) {
        let currentLimit = self.prefs.historyLimit
        var confirm: Bool
        if limitChangeIsDestructive(limit: limit,
                                    currentLimit: currentLimit) {
            confirm = confirmationDialog(question: "Reduce Pasteboard History Limit?",
                                     text: "Warning: You'll lose items beyond the new limit, you cannot undo this.  Click OK to continue.")
        } else {
            confirm = true
        }

        if confirm {
            self.prefs.historyLimit = limit
        } else {
            self.historyLimitTextField.stringValue = String(currentLimit)
        }
    }
}

func confirmationDialog(question: String,
                    text: String,
                    ok: String = "OK",
                    cancel: String = "Cancel") -> Bool {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: ok)
    alert.addButton(withTitle: cancel)
    return alert.runModal() == .alertFirstButtonReturn
}
