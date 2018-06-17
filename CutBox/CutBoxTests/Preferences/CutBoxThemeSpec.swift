//
//  CutBoxThemeSpec.swift
//  CutBoxTests
//
//  Created by Jason on 22/4/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import Quick
import Nimble

@testable import CutBox

class CutBoxThemeSpec: QuickSpec {
    override func spec() {
        describe("CutBoxTheme") {
            // swiftlint:disable colon
            let subject = CutBoxColorTheme(
                name: "Creamblue".l7n,
                popupBackgroundColor:            #colorLiteral(red: 0.1098039216, green: 0.1098039216, blue: 0.1098039216, alpha: 1),
                searchText: (
                    cursorColor:                 #colorLiteral(red: 0.5294117647, green: 0.8431372549, blue: 1, alpha: 1),
                    textColor:                   #colorLiteral(red: 0.5294117647, green: 0.8431372549, blue: 1, alpha: 1),
                    backgroundColor:             #colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.1960784314, alpha: 1),
                    placeholderTextColor:        #colorLiteral(red: 0.1591003184, green: 0.2392678358, blue: 0.2553013393, alpha: 1)
                ),
                clip: (
                    clipItemsBackgroundColor:    #colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.1960784314, alpha: 1),
                    clipItemsTextColor:          #colorLiteral(red: 0.5294117647, green: 0.8431372549, blue: 1, alpha: 1),
                    clipItemsHighlightColor:     #colorLiteral(red: 0.5529411765, green: 0.8196078431, blue: 0.7921568627, alpha: 0.1513259243),
                    clipItemsHighlightTextColor: #colorLiteral(red: 0.5294117647, green: 0.8431372549, blue: 1, alpha: 1)
                ),
                preview: (
                    textColor:                   #colorLiteral(red: 0.5294117647, green: 0.8431372549, blue: 1, alpha: 1),
                    backgroundColor:             #colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.1960784314, alpha: 1),
                    selectedTextBackgroundColor: #colorLiteral(red: 0.5529411765, green: 0.8196078431, blue: 0.7921568627, alpha: 0.1513259243)
                ),
                spacing: 5
            )
            // swiftlint:enable colon

            it("holds a list of all instantiated color themes") {
                expect(CutBoxColorTheme.instances.contains(where: { $0.name == subject.name })).to(beTrue())
            }
        }
    }
}
