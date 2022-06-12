//
//  CutBoxPreferences+SelectTheme.swift
//  CutBox
//
//  Created by Jason Milkins on 12/4/18.
//  Copyright © 2019-2020 ocodo. All rights reserved.
//

import Foundation

extension CutBoxPreferencesService {

    var theme: Int {
        get {
            let temp = defaults.integer(forKey: "theme")
            if themes.count - 1 < temp {
                self.theme = 0
                return 0
            }
            return temp
        }
        set {
            defaults.set(newValue, forKey: "theme")
            self.events.onNext(.themeChanged)
        }
    }

    var currentTheme: CutBoxColorTheme { return themes[theme] }

    func toggleTheme() {
        theme = ((theme + 1) % themes.count)
    }
}
