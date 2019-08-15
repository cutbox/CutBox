//
//  PreferencesAdvancedView+HistorySize.swift
//  CutBox
//
//  Created by Jason on 11/5/18.
//  Copyright © 2019 ocodo. All rights reserved.
//

import RxSwift
import Foundation

extension PreferencesAdvancedView {

    func setupHistorySizeLabel() {
        updateHistorySizeLabel()

        HistoryService.shared
            .events
            .subscribe(onNext: { _ in self.updateHistorySizeLabel() })
            .disposed(by: disposeBag)
    }

    func updateHistorySizeLabel() {
        self.historySizeLabel.stringValue = String(
            format: "preferences_history_is_using_format".l7n,
            HistoryService.shared.bytesFormatted()
        )
    }

}
