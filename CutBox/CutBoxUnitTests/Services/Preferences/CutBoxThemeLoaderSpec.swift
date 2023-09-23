//
//  CutBoxThemeLoaderSpec.swift
//  CutBoxUnitTests
//
//  Created by jason on 23/9/23.
//  Copyright © 2023 ocodo. All rights reserved.
//

import Quick
import Nimble

class CutBoxThemeLoaderSpec: QuickSpec {
    override func spec() {
        describe("CutBoxThemeLoader") {
            let subject = CutBoxThemeLoader()

            it("loads bundled themes") {
                let result = subject.getBundledThemes()
                expect(result.count) == 12
            }
            context("loads user themes from a given location") {
                it("loads no themes if the location is non-existent") {
                    subject.cutBoxUserThemesLocation = ""
                    let result = subject.getUserThemes()
                    expect(result.count) == 0
                }

                it("loads themes if there are any in the location path") {
                    let tempUserTheme: String = fakeThemeJson()
                    let temporaryDirectory = FileManager.default.temporaryDirectory.path
                    let tempUserThemeFilename = "temporal.cutboxTheme"

                    createTestFile(
                        path: "\(temporaryDirectory)/\(tempUserThemeFilename)",
                        contents: tempUserTheme)

                    subject.cutBoxUserThemesLocation = temporaryDirectory
                    let result = subject.getUserThemes()
                    expect(result.count) == 1
                }
            }
        }
    }
}
