//
//  CutBoxPreferences+SelectTheme.swift
//  CutBox
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

extension CutBoxPreferencesService {
    var theme: Int {
        set {
            defaults.set(newValue, forKey: "theme")
        }

        get {
            return defaults.integer(forKey: "theme")
        }
    }

    var themes: [CutBoxColorTheme] {
        return CutBoxColorTheme.instances
    }

    func toggleTheme() {
        theme = ((theme + 1) % themes.count)
    }
}
