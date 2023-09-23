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


func fakeThemeJson() -> String {
    return """
               {
                   "name": "Test Theme",
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
               """
}

class CutBoxThemeSpec: QuickSpec {
    override func spec() {
        describe("CutBoxTheme") {
            let subjectA = CutBoxColorTheme(
                name: "Test Theme",
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

            let subjectB = CutBoxColorTheme(fakeThemeJson())
            let subjectC = CutBoxColorTheme(name: "Test Theme", theme: subjectA)
            let subjectD = CutBoxColorTheme(name: "Borked Name", theme: subjectC)

            context("JSON decoding errors") {
                context("throws assertion when") {
                    it("attempts decoding of corrupt json") {
                        let json = "{{{{{This isn't going to end well for the decoder!"
                        expect { CutBoxColorTheme(json) }.to(throwAssertion())
                    }

                    it("attempts decoding of json with no properties") {
                        let json = "{}"
                        expect { CutBoxColorTheme(json) }.to(throwAssertion())
                    }

                    it("attempts decoding of json with mismatched property type") {
                        let json = fakeThemeJson()
                            .replacingOccurrences(
                                of: "\"spacing\": 1.0",
                                with: "\"spacing\": \"ABC\""
                            )

                        expect { CutBoxColorTheme(json) }.to(throwAssertion())
                    }

                    it("attempts decoding of json with missing property") {
                        let json = fakeThemeJson()
                            .replacingOccurrences(
                                of: "\"name\": \"Test Theme\",",
                                with: "\"name\":,"
                            )

                        expect { CutBoxColorTheme(json) }.to(throwAssertion())
                    }
                }
            }

            context("theme initialization") {
                describe("should match") {
                    it("should match themes based on the same definition") {
                        expect(subjectA) == subjectB
                        expect(subjectB) == subjectC
                    }

                    it("should not match themes with different names") {
                        expect(subjectA) != subjectD
                    }
                }
            }
        }
    }
}
