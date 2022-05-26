//
//  PreferencesThemeSelectionView+ThemeSelector.swift
//  CutBox
//
//  Created by Jason Milkins on 11/5/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Foundation

extension PreferencesThemeSelectionView {

    func setupThemeSelector() {
        self.themeSelectorTitleLabel.stringValue =
            "preferences_color_theme_title".l7n

        self.themeSelectorMenu.addItems(withTitles:
            CutBoxColorTheme.list.map { $0.name }
        )

        self.themeSelectorMenu.selectItem(at: prefs.theme)
    }

}
