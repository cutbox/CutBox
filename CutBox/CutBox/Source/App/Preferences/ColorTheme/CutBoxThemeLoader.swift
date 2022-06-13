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

        let themes: [CutBoxColorTheme] = themePaths.sorted().map {
            do {
                return CutBoxColorTheme(try String(contentsOfFile: $0))
            } catch {
                print("There was a problem reading bundled theme: $0", to: &errStream)
                abort()
            }
        }

        return themes
    }

    static func getUserThemes() -> [CutBoxColorTheme] {
        let jsonThemes = loadUserThemesFiles()
        let userThemeIdentifier = "*"

        return jsonThemes.map {
            let theme = CutBoxColorTheme($0)
            return CutBoxColorTheme(
                name: "\(theme.name) \(userThemeIdentifier)",
                theme: theme
            )
        }
    }

    private static func loadUserThemesFiles() -> [String] {
        let f = FileManager.default
        let cutBoxConfig = String(NSString(
            string: "~/.config/cutbox"
        ).expandingTildeInPath)

        guard let themefiles = try?
                f.contentsOfDirectory(atPath: cutBoxConfig) else { return [] }

        let jsonThemes: [String] = themefiles
            .filter { $0.hasSuffix(".cutboxTheme") }
            .sorted()
            .map { getStringFromFile("\(cutBoxConfig)/\($0)")! }

        return jsonThemes
    }
}
