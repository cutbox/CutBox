//
//  CutBoxThemeLoader.swift
//  CutBox
//
//  Created by Jason on 30/5/22.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Foundation

class CutBoxThemeLoader {

    var cutBoxUserThemesLocation: String!

    func getBundledThemes() -> [CutBoxColorTheme] {
        let bundle = Bundle(for: Self.self)

        let themePaths: [String] = bundle
            .paths(forResourcesOfType: "cutboxTheme",
                   inDirectory: "themes")

        let themes: [CutBoxColorTheme] = themePaths.sorted()
            .map { try? String(contentsOfFile: $0) }
            .compactMap { $0 }
            .map { CutBoxColorTheme($0) }

        return themes
    }

    func getUserThemes() -> [CutBoxColorTheme] {
        let jsonThemes = loadUserThemesFiles()
        let userThemeIdentifier = "*"

        return jsonThemes.map { let theme = CutBoxColorTheme($0)
            return CutBoxColorTheme(
                name: "\(theme.name) \(userThemeIdentifier)",
                theme: theme
            )
        }
    }

    func loadUserThemesFiles() -> [String] {
        let fileManager = FileManager.default
        let cutBoxConfig = String(NSString(
            string: cutBoxUserThemesLocation
        ).expandingTildeInPath)

        guard let themefiles = try?
                fileManager.contentsOfDirectory(atPath: cutBoxConfig) else { return [] }

        let jsonThemes: [String] = themefiles
            .filter { $0.hasSuffix(".cutboxTheme") }
            .sorted()
            .map { getStringFromFile("\(cutBoxConfig)/\($0)")! }

        return jsonThemes
    }
}
