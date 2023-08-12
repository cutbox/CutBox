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
            if let name = defaults.string(forKey: "themeName"),
            let index = themes.firstIndex(where: { $0.name == name }) {
                return index
            }

            let temp = defaults.integer(forKey: "theme")
            if themes.count - 1 < temp {
                self.theme = 0
                return 0
            }
            return temp
        }
        set {
            defaults.set(newValue, forKey: "theme")
            defaults.set(themes[newValue].name, forKey: "themeName")
            self.events.onNext(.themeChanged)
        }
    }

    var themeName: String {
        if let name = defaults.string(forKey: "themeName"),
            themes.contains(where: { $0.name == name }) {
            return name
        }
        return themes[theme].name
    }

    var currentTheme: CutBoxColorTheme { return themes[theme] }

    func toggleTheme() {
        theme = ((theme + 1) % themes.count)
    }
}
