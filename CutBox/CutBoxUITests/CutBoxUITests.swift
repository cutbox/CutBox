//
//  CutBoxUITests.swift
//  CutBoxUITests
//
//  Created by Jason on 29/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import XCTest

class CutBoxUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments = ["ui-testing"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGeneralUI() {
        let app = XCUIApplication()
        let textView = app.groups
            .containing(.image,
                        identifier:"cutbox icon 2 preview")
            .children(matching: .group)
            .element(boundBy: 0)
            .scrollViews
            .children(matching: .textView)
            .element

        textView.typeText("app")
        textView.typeKey("s", modifierFlags:.command)

        textView.clearAndEnterText(text: "app")
        textView.typeKey("s", modifierFlags:.command)

        textView.clearAndEnterText(text: "App")
        textView.typeKey("s", modifierFlags:.command)

        textView.typeKey("f", modifierFlags:.command)
        textView.typeKey("f", modifierFlags:.command)
        
        let image = app.tables
            .children(matching: .tableRow)
            .element(boundBy: 0)
            .children(matching: .cell)
            .element(boundBy: 0)
            .children(matching: .image)
            .element

        image.rightClick()
        
        let toggleFavoriteMenuItem = app.tables.menuItems["Toggle Favorite"]
        toggleFavoriteMenuItem.click()
        image.rightClick()
        toggleFavoriteMenuItem.click()

        let iconTable = app
            .tables
            .containing(.tableColumn, identifier: "icon")
            .element

        iconTable.typeKey(.downArrow, modifierFlags:[])
        iconTable.typeKey(.downArrow, modifierFlags:[])
        iconTable.typeKey(.downArrow, modifierFlags:[])
        iconTable.typeKey(.upArrow, modifierFlags:[])

        let row = app.tables
            .tableRows
            .cells
            .staticTexts
            .firstMatch

        row.rightClick()

        app.tables.menuItems["Remove Selected"].click()
        iconTable.typeKey(.downArrow, modifierFlags:[])
        iconTable.typeKey(.downArrow, modifierFlags:[])
        iconTable.typeKey(.delete, modifierFlags:.command)
        iconTable.typeKey(.downArrow, modifierFlags:[])
        iconTable.typeKey(.downArrow, modifierFlags:[])
    }
}

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
