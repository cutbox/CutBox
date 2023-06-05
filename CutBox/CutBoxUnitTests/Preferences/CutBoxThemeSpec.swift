//
//  CutBoxThemeSpec.swift
//  CutBoxUnitTests
//
//  Created by Jason on 30/5/22.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble
import JSONSchema

class CutBoxPreferencesServiceSpec: QuickSpec {
    override func spec() {
        describe("CutBoxPreferencesServiceSpec") {
            let subject = CutBoxPreferencesService()
            let bundledThemes = subject.themes
                .map { $0.name }
                .filter { !$0.contains("*") } // Filter out user themes

            it("initializes with bundled themes") {
                expect(bundledThemes.count).to(equal(10))
                expect(bundledThemes)
                    .to(equal([
                    "Darkness",
                    "Skylight",
                    "Sandy Beach",
                    "Darktooth",
                    "Creamsody",
                    "Purplehaze",
                    "Verdant",
                    "Amber Cathode",
                    "macOS",
                    "macOS Graphite"
                ]))
            }
        }
    }
}

class CutBoxThemeSpec: QuickSpec {
    override func spec() {
        describe("CutBoxThemeSpec", {
            let subjectA = CutBoxColorTheme(
                name: "TestTheme",
                popupBackgroundColor: "#444444".color!,
                searchText:
                    SearchTextTheme( cursorColor: "#444444".color!,
                                     textColor: "#444444".color!,
                                     backgroundColor: "#333333".color!,
                                     placeholderTextColor: "#FFFFFF".color! ),
                clip:
                    ClipTheme(
                        backgroundColor: "#444444".color!,
                        textColor: "#FFFFFF".color!,
                        highlightColor: "#0000FF".color!,
                        highlightTextColor: "#FFFFFF".color!
                    ),
                preview:
                    PreviewTheme(
                        textColor: "#EEEEEE".color!,
                        backgroundColor: "#000000".color!,
                        selectedTextBackgroundColor: "#FF0000".color!,
                        selectedTextColor: "#EEEEEE".color!
                    ),
                spacing: 1.0
            )

            let subjectB = CutBoxColorTheme("""
                {
                    "name": "TestTheme",
                    "popupBackgroundColor": "#444444",
                    "searchText": {
                        "cursorColor": "#444444",
                        "textColor": "#444444",
                        "backgroundColor": "#333333",
                        "placeholderTextColor": "#FFFFFF"
                    },
                    "clip": {
                        "backgroundColor": "#444444",
                        "textColor": "#FFFFFF",
                        "highlightColor": "#0000FF",
                        "highlightTextColor": "#FFFFFF"
                    },
                    "preview": {
                        "textColor": "#EEEEEE",
                        "backgroundColor": "#000000",
                        "selectedTextBackgroundColor": "#FF0000",
                        "selectedTextColor": "#EEEEEE"
                    },
                    "spacing": 1.0
                }
            """)

            describe("should match") {

                it("name") {
                    expect(subjectA.name).to(equal(subjectB.name))
                }

                it("clip items") {
                    expect(subjectA.clip.textColor)
                        .to(equal(subjectB.clip.textColor))
                    expect(subjectA.clip.highlightColor)
                        .to(equal(subjectB.clip.highlightColor))
                    expect(subjectA.clip.highlightTextColor)
                        .to(equal(subjectB.clip.highlightTextColor))
                }

                it("preview") {
                    expect(subjectA.preview.textColor)
                        .to(equal(subjectB.preview.textColor))
                    expect(subjectA.preview.backgroundColor)
                        .to(equal(subjectB.preview.backgroundColor))
                    expect(subjectA.preview.selectedTextBackgroundColor)
                        .to(equal(subjectB.preview.selectedTextBackgroundColor))
                    expect(subjectA.preview.selectedTextColor)
                        .to(equal(subjectB.preview.selectedTextColor))
                }

                it("search") {
                    expect(subjectA.searchText.textColor)
                        .to(equal(subjectB.searchText.textColor))
                    expect(subjectA.searchText.cursorColor)
                        .to(equal(subjectB.searchText.cursorColor))
                    expect(subjectA.searchText.placeholderTextColor)
                        .to(equal(subjectB.searchText.placeholderTextColor))
                    expect(subjectA.searchText.backgroundColor)
                        .to(equal(subjectB.searchText.backgroundColor))
                }
            }
        })
    }
}
