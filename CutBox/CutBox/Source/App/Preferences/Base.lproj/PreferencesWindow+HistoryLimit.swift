//
//  PreferencesWindow+HistoryLimit.swift
//  CutBox
//
//  Created by Jason on 14/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import RxCocoa
import RxSwift

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
        if prefs.suppressHistoryLimitWarning { return false }

        return (limit > 0 && currentLimit == 0) ||
            (limit > 0 && currentLimit > limit)
    }

    func setHistoryLimitWithConfirmation(_ limit: Int) {
        let currentLimit = self.prefs.historyLimit
        var confirm: Bool
        var suppress: Bool
        if limitChangeIsDestructive(limit: limit,
                                    currentLimit: currentLimit) {
            (confirm, suppress) = confirmationDialog(
                question: "preferences_history_destructive_limit_change_warning_title".l10n(),
                text: "preferences_history_destructive_limit_change_warning_description".l10n(),
                showSuppressionOption: !prefs.suppressHistoryLimitWarning
            )

            prefs.suppressHistoryLimitWarning = suppress
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
