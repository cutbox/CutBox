//
//  XCUIElement+clearAndEnterText.swift
//  CutBoxUITests
//
//  Created by Jason on 1/6/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import XCTest

extension XCUIElement {

    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        let deleteString = stringValue
            .map { _ in "\u{8}" }
            .joined(separator: "")

        self.typeText(deleteString)
        self.typeText(text)
    }

}
