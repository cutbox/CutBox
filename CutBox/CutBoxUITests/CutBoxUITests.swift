//
//  CutBoxUITests.swift
//  CutBoxUITests
//
//  Created by Jason on 29/5/18.
//  Copyright © 2018 ocodo. All rights reserved.
//

import XCTest

class AboutUITest: XCTestCase {
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testAboutUI() {
        let app = XCUIApplication()

        let cutBoxStatusItem = app.statusItems.firstMatch

        cutBoxStatusItem
            .click()

        cutBoxStatusItem
            .menuItems["About CutBox"].click()

        let about = app.windows.firstMatch
        XCTAssert(about.staticTexts["CutBox"].exists)
    }
}

class PreferencesUITest: XCTestCase {
    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testPreferencesUI() {
        let app = XCUIApplication()

        let cutBoxStatusItem = app.statusItems.firstMatch

        cutBoxStatusItem
            .click()

        cutBoxStatusItem
            .menuItems["Preferences"].click()

        let prefs = app.windows.firstMatch

        let display = prefs.tabs["Display"]
        let advanced = prefs.tabs["Advanced"]
        let javascript = prefs.tabs["Javascript"]
        let general = prefs.tabs["General"]

        display.click()
        display.click()
        let displayCheckBoxes = prefs.checkBoxes

        // Compact UI Checkbox
        displayCheckBoxes["Use Compact UI"].click()
        displayCheckBoxes["Use Compact UI"].click()

        // Theme drop down
        let themePopup = prefs.popUpButtons.firstMatch
        themePopup.click()
        themePopup.typeKey(.upArrow, modifierFlags: [])
        themePopup.typeKey(.upArrow, modifierFlags: [])
        themePopup.typeKey(.upArrow, modifierFlags: [])
        themePopup.typeKey(.upArrow, modifierFlags: [])
        themePopup.typeKey(.downArrow, modifierFlags: [])
        themePopup.typeKey(.downArrow, modifierFlags: [])
        themePopup.typeKey(.downArrow, modifierFlags: [])
        themePopup.typeKey(.downArrow, modifierFlags: [])
        themePopup.typeKey(.enter, modifierFlags: [])

        general.click()
        let generalCheckBoxes = prefs.descendants(matching: .checkBox)

        // Login checkbox
        generalCheckBoxes["Launch on Login"].click()
        generalCheckBoxes["Launch on Login"].click()

        generalCheckBoxes["Protect favorites"].click()
        generalCheckBoxes["Protect favorites"].click()

        advanced.click()
        let advancedCheckBoxes = prefs.checkBoxes

        // Unlimited history checkbox
        advancedCheckBoxes["Unlimited"].click()
        advancedCheckBoxes["Unlimited"].click()

        advancedCheckBoxes["Wrap text around joined clips?"].click()
        advancedCheckBoxes["Wrap text around joined clips?"].click()

        javascript.click()
        let jsButtons = prefs.descendants(matching: .button)

        XCTAssert(prefs.staticTexts["Javascript REPL"].exists)

        XCTAssert(prefs.staticTexts["Use this to help debug your ~/.cutbox.js"].exists)

        let replTextView = prefs.textViews.firstMatch

        XCTAssertEqual(replTextView.value as? String,
                       """
                       CutBox JS REPL:

                       help ENTER, for help


                       """)

        jsButtons["Clear"].click()

        XCTAssertEqual(replTextView.value as? String, "")

        // Reload JS button
        jsButtons["Reload ~/.cutbox.js"].click()
    }
}

// - - -

class HistorySearchUITest: XCTestCase {

    override func setUp() {
        super.setUp()

        continueAfterFailure = false

        let app = XCUIApplication()
        app.launchArguments = ["search-ui-test"]
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSearchUI() {
        let app = XCUIApplication()
        let textView = app.groups
            .containing(.image,
                        identifier: "cutbox icon")
            .children(matching: .group)
            .element(boundBy: 0)
            .scrollViews
            .children(matching: .textView)
            .element

        textView.typeText("app")
        textView.typeKey("s", modifierFlags: .command)

        textView.clearAndEnterText(text: "app")
        textView.typeKey("s", modifierFlags: .command)

        textView.clearAndEnterText(text: "App")
        textView.typeKey("s", modifierFlags: .command)

        textView.typeKey("f", modifierFlags: .command)
        textView.typeKey("f", modifierFlags: .command)

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

        iconTable.typeKey(.downArrow, modifierFlags: [])
        iconTable.typeKey(.downArrow, modifierFlags: [])
        iconTable.typeKey(.downArrow, modifierFlags: [])
        iconTable.typeKey(.upArrow, modifierFlags: [])

        let row = app.tables
            .tableRows
            .cells
            .staticTexts
            .firstMatch

        row.rightClick()

        app.tables.menuItems["Remove Selected"].click()
        iconTable.typeKey(.downArrow, modifierFlags: [])
        iconTable.typeKey(.downArrow, modifierFlags: [])
        iconTable.typeKey(.delete, modifierFlags: .command)
        iconTable.typeKey(.downArrow, modifierFlags: [])
        iconTable.typeKey(.downArrow, modifierFlags: [])

        app.buttons["jsIconButton"].click()

        iconTable.typeKey(.downArrow, modifierFlags: [])
        iconTable.typeKey(.downArrow, modifierFlags: [])
        iconTable.typeKey(.downArrow, modifierFlags: [])
        iconTable.typeKey(.downArrow, modifierFlags: [])
        iconTable.typeKey(.upArrow, modifierFlags: [])
        iconTable.typeKey(.upArrow, modifierFlags: [])
        iconTable.typeKey(.upArrow, modifierFlags: [])
        iconTable.typeKey(.upArrow, modifierFlags: [])
    }
}
