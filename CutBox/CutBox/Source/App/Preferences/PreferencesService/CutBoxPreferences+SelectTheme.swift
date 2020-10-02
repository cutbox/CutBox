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
            return defaults.integer(forKey: "theme")
        }
        set {
            defaults.set(newValue, forKey: "theme")
            self.events.onNext(.themeChanged)
        }
    }

    var themes: [CutBoxColorTheme] {
        return CutBoxColorTheme.instances
    }

    func toggleTheme() {
        theme = ((theme + 1) % themes.count)
    }

}
