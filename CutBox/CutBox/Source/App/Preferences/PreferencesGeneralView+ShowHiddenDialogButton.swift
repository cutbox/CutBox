//
//  PreferencesGeneralView+ShowHiddenDialogButton.swift
//  CutBox
//
//  Created by Jason Milkins on 11/5/20.
//  Copyright © 2020 ocodo. All rights reserved.
//

import Foundation

extension PreferencesGeneralView {

    func setupShowAllHiddenDialogBoxesButton() {
        self.showAllHiddenDialogBoxesButton.toolTip = "preferences_show_all_hidden_dialog_boxes_button_tootip".l7n
        self.showAllHiddenDialogBoxesButton.title = "preferences_show_all_hidden_dialog_boxes_button_title".l7n

        self.showAllHiddenDialogBoxesButton
            .rx
            .tap
            .bind { [self] in
                resetAllHiddenDialogBoxes()
            }
            .disposed(by: disposeBag)
    }

    func resetAllHiddenDialogBoxes() {
        for key in self.prefs.defaults.dictionaryRepresentation().keys
        where key.contains("CutBoxSuppressed") {
            self.prefs.defaults.removeObject(forKey: key)
        }
    }
}
