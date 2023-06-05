//
//  PreferencesThemeSelectionView+ThemeSelector.swift
//  CutBox
//
//  Created by Jason Milkins on 11/5/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Foundation

extension PreferencesThemeSelectionView {

    func setupThemeSelector() {
        self.themeSelectorTitleLabel.stringValue =
            "preferences_color_theme_title".l7n

        self.reloadThemesButton.title = "preferences_color_theme_reload_themes".l7n

        self.reloadThemesButton
            .rx
            .tap
            .bind { [self] in
                CutBoxPreferencesService
                    .shared
                    .loadThemes()

                self.setupThemesList()
                self.themeSelectorMenu
                    .selectItem(at: prefs.theme)
            }
            .disposed(by: disposeBag)

        self.setupThemesList()

        self.themeSelectorMenu
            .selectItem(at: prefs.theme)
    }

    func setupThemesList() {
        self.themeSelectorMenu
            .addItems(
                withTitles: CutBoxPreferencesService
                    .shared
                    .themes
                    .map { $0.name })
    }
}
