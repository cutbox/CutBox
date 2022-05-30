//
//  CutBoxThemeSpec.swift
//  CutBoxUnitTests
//
//  Created by Jason on 30/5/22.
//  Copyright © 2022 ocodo. All rights reserved.
//

import Quick
import Nimble

class CutBoxPreferencesServiceSpec: QuickSpec {
    override func spec() {
        describe("CutBoxPreferencesServiceSpec") {
            let subject = CutBoxPreferencesService()

            it("initializes with themes") {
                expect(subject.themes.count).to(equal(10))
                expect(subject.themes.map({ $0.name })).to(equal([
                    "preferences_color_theme_name_darkness",
                    "preferences_color_theme_name_skylight",
                    "preferences_color_theme_name_sandy_beach",
                    "preferences_color_theme_name_darktooth",
                    "preferences_color_theme_name_creamsody",
                    "preferences_color_theme_name_purplehaze",
                    "preferences_color_theme_name_verdant",
                    "preferences_color_theme_name_amber_cathode",
                    "preferences_color_theme_name_macos",
                    "preferences_color_theme_name_macos_graphite"
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
                        clipItemsBackgroundColor: "#444444".color!,
                        clipItemsTextColor: "#FFFFFF".color!,
                        clipItemsHighlightColor: "#0000FF".color!,
                        clipItemsHighlightTextColor: "#FFFFFF".color!
                    ),
                preview:
                    PreviewTheme(
                        textColor: "#EEEEEE".color!,
                        backgroundColor: "#000000".color!,
                        selectedTextBackgroundColor: "#FF0000".color!
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
                        "clipItemsBackgroundColor": "#444444",
                        "clipItemsTextColor": "#FFFFFF",
                        "clipItemsHighlightColor": "#0000FF",
                        "clipItemsHighlightTextColor": "#FFFFFF"
                    },
                    "preview": {
                        "textColor": "#EEEEEE",
                        "backgroundColor": "#000000",
                        "selectedTextBackgroundColor": "#FF0000"
                    },
                    "spacing": 1.0
                }
            """)

            describe("should match") {

                it("name") {
                    expect(subjectA.name).to(equal(subjectB.name))
                }

                it("clip items") {
                    expect(subjectA.clip.clipItemsTextColor)
                        .to(equal(subjectB.clip.clipItemsTextColor))
                    expect(subjectA.clip.clipItemsHighlightColor)
                        .to(equal(subjectB.clip.clipItemsHighlightColor))
                    expect(subjectA.clip.clipItemsHighlightTextColor)
                        .to(equal(subjectB.clip.clipItemsHighlightTextColor))
                }

                it("preview") {
                    expect(subjectA.preview.textColor)
                        .to(equal(subjectB.preview.textColor))
                    expect(subjectA.preview.backgroundColor)
                        .to(equal(subjectB.preview.backgroundColor))
                    expect(subjectA.preview.selectedTextBackgroundColor)
                        .to(equal(subjectB.preview.selectedTextBackgroundColor))
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
