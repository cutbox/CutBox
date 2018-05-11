//
//  Preferences+ThemeSelector.swift
//  CutBox
//
//  Created by Jason on 11/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

extension PreferencesWindow {
    func setupThemeSelector() {
        self.themeSelectorTitleLabel.stringValue =
            "preferences_color_theme_title".l7n

        self.themeSelectorMenu.addItems(withTitles:
            CutBoxColorTheme.instances.map { $0.name }
        )

        self.themeSelectorMenu.selectItem(at: prefs.theme)
    }
}
