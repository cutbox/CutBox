//
//  CutBoxThemeLoader.swift
//  CutBox
//
//  Created by Jason on 30/5/22.
//  Copyright © 2022 ocodo. All rights reserved.
//

import Foundation

class CutBoxThemeLoader {

    static func getBundledThemes() -> [CutBoxColorTheme] {
        let bundle = Bundle(for: Self.self)

        let themePaths: [String] = bundle
            .paths(forResourcesOfType: "cutboxTheme",
                   inDirectory: "themes")

        let themes: [CutBoxColorTheme] = themePaths.sorted().map({
            do {
                let json = try String(contentsOfFile: $0)
                let theme = CutBoxColorTheme(json)
                return theme
            } catch {
                print("There was a problem reading bundle theme: $0")
                abort()
            }
        })

        return themes
    }
}
