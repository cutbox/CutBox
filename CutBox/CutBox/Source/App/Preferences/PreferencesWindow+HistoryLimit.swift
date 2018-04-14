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
        self.historyUnlimitedCheckbox
            .rx
            .state
            .map { $0 == .off }
            .subscribe(onNext:
                { self.prefs.historyUnlimited = $0 })
            .disposed(by: disposeBag )

        self.historyUnlimitedCheckbox
            .rx
            .state
            .map { $0 == .off }
            .subscribe(onNext:
                { self.historyLimitTextField.isEnabled = $0 })
            .disposed(by: disposeBag)

        if let historyLimit = prefs.historyLimit {
            self.historyLimitTextField.stringValue = historyLimit
        } else {
            self.historyLimitTextField.stringValue = ""
        }

        if prefs.historyUnlimited {
            self.historyUnlimitedCheckbox.state = .off
        } else {
            self.historyUnlimitedCheckbox.state = .on
        }
    }
}
