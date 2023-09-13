//
//  PreferencesAdvancedView+ClearHistory.swift
//  CutBox
//
//  Created by Jason Milkins on 15/8/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import RxCocoa
import RxSwift

extension PreferencesAdvancedView {
    func setupClearHistoryControls() {
        clearHistoryDropDown.removeAllItems()
        clearHistoryDropDown.addItems(withTitles: clearHistoryOptions.map { $0.title })
        clearHistoryActionButton.title = "preferences_history_clear_history_button".l7n
        clearHistoryActionButton.rx.tap
            .bind(onNext: clearHistoryActionClicked)
            .disposed(by: disposeBag)
    }

    func clearHistoryActionClicked() {
        let selectedIndex = clearHistoryDropDown.indexOfSelectedItem
        if let offset = clearHistoryOptions[selectedIndex].offset {
            if dialogFactory.suppressibleConfirmationDialog(
                messageText: "\(clearHistoryOptions[selectedIndex].title.l7n)?",
                informativeText: "confirm_warning_clear_history".l7n,
                dialogName: .clearHistoryActionClicked) {
                prefs.events.onNext(.historyClearByOffset(offset: offset))
            }
        }
    }
}
