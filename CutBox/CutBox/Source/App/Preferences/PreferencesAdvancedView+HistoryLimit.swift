//
//  PreferencesAdvancedView+HistoryLimit.swift
//  CutBox
//
//  Created by Jason Milkins on 14/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import RxCocoa
import RxSwift

extension PreferencesAdvancedView {

    func setupHistoryLimitControls() {
        self.setupHistoryUnlimitedCheckbox()
        self.setupHistoryLimitTextField()
    }

    func setupHistoryUnlimitedCheckbox() {
        self.historyUnlimitedCheckbox.title = "preferences_history_limit_checkbox_label".l7n

        self.historyUnlimitedCheckbox.state = prefs
            .historyLimited
            ? .off
            : .on

        self.historyUnlimitedCheckbox
            .rx
            .state
            .map { $0 == .off }
            .subscribe(onNext: {
                self.prefs.historyLimited = $0
                self.historyLimitTextField.isEnabled = $0
                if !$0 {
                    self.historyLimitTextField.stringValue = ""
                }
            })
            .disposed(by: disposeBag)
    }

    func setupHistoryLimitTextField() {
        let historyLimit = prefs.historyLimit

        self.historyLimitTitle.stringValue = "preferences_history_limit_title".l7n
        self.historyLimitTextField.placeholderString = "preferences_history_limit_placeholder".l7n

        self.historyLimitTextField.formatter = HistoryLimitNumberFormatter()

        self.historyLimitTextField.stringValue = String(historyLimit)

        self.historyLimitTextField
            .rx
            .controlEvent // end editing
            .subscribe(onNext: {
                let limit = Int(self.historyLimitTextField.stringValue) ?? 0
                self.setHistoryLimitWithConfirmation(limit)
            })
            .disposed(by: disposeBag)
    }

    func setHistoryLimitWithConfirmation(_ limit: Int) {
        let currentLimit = self.prefs.historyLimit

        if limitChangeIsDestructive(limit: limit, currentLimit: currentLimit) {
            if dialogFactory.suppressibleConfirmationDialog(
                messageText: "confirm_warning_clear_history_title".l7n,
                informativeText: "confirm_warning_clear_history".l7n,
                dialogName: .destructiveLimitChangeWarning) {
                self.prefs.historyLimit = limit
            } else {
                self.historyLimitTextField.stringValue = String(currentLimit)
            }
        }
    }

    func limitChangeIsDestructive(limit: Int, currentLimit: Int) -> Bool {
        return (limit > 0 && currentLimit == 0) ||
            (limit > 0 && currentLimit > limit)
    }
}
