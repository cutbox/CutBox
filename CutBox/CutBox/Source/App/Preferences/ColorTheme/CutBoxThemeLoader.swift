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

    static func getUserThemes() -> [CutBoxColorTheme] {
        let jsonThemes = loadUserThemesFiles()
        let userThemeIdentifier = "*"

        return jsonThemes.map {
            let theme = CutBoxColorTheme($0)

            return CutBoxColorTheme(name: "\(theme.name) \(userThemeIdentifier)",
                                    popupBackgroundColor: theme.popupBackgroundColor,
                                    searchText: theme.searchText,
                                    clip: theme.clip,
                                    preview: theme.preview,
                                    spacing: theme.spacing
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

        let jsonThemes: [String] = themefiles.sorted().map({
            let filepath = "\(cutBoxConfig)/\($0)"
            let json = getStringFromFile(filepath)!
            return json
        })

        return jsonThemes
    }
}
