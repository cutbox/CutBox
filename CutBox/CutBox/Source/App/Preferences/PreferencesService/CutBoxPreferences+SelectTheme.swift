//
//  CutBoxPreferences+SelectTheme.swift
//  CutBox
//
//  Created by Jason Milkins on 12/4/18.
//  Copyright © 2018-2023 ocodo. All rights reserved.
//

import Foundation

extension CutBoxPreferencesService {
    var theme: Int {
        get {
            // 1.5.8 - theme saved to prefs as themeName
            if let name = defaults.string(forKey: "themeName"),
            let index = themes.firstIndex(where: { $0.name == name }) {
                return index
            }

            let legacyIndex = defaults.integer(forKey: "theme")
            if themes.count < legacyIndex + 1 {
                self.theme = 0
                return 0
            }
            return legacyIndex
        }

        set {
            // 1.5.8 - theme saved to prefs as themeName
            defaults.set(themes[newValue].name, forKey: "themeName")

            defaults.set(newValue, forKey: "theme")
            self.events.onNext(.themeChanged)
        }
    }

    var themeName: String {
        if let name = defaults.string(forKey: "themeName"),
           let themeIndex = themes.firstIndex(where: { $0.name == name }) {
            theme = themeIndex
            return name
        }
        return themes[theme].name
    }

    var currentTheme: CutBoxColorTheme { return themes[theme] }

    func cycleTheme() {
        theme = (theme + 1) % themes.count
    }
}
