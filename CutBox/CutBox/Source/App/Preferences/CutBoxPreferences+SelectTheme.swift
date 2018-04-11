//
//  CutBoxPreferences+SelectTheme.swift
//  CutBox
//
//  Created by Jason on 12/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Foundation

extension CutBoxPreferences {
    var theme: Int {
        set {
            UserDefaults.standard.set(newValue, forKey: "theme")
        }

        get {
            return UserDefaults.standard.integer(forKey: "theme")
        }
    }

    var themes: [CutBoxColorTheme] {
        return [
            self.darkTheme,
            self.lightTheme
        ]
    }
}
