//
//  TravnerUITests.swift
//  TravnerUITests
//
//  Created by Lorenzo Lins Mazzarotto on 01/05/22.
//

import XCTest

class TravnerUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

        app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }

    func testAppHas5Tabs() throws {
        XCTAssertEqual(app.tabBars.buttons.count, 5, "There should be 5 tabs in the app.")
    }

    func testOpenTabAddsGuides() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        for tapCount in 1...3 {
            app.buttons["Add Guide"].tap()
            XCTAssertEqual(app.tables.cells.count, tapCount, "There should be \(tapCount) rows(s) in the list.")
        }
    }

    func testAddingItemInsertsRows() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add Guide"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a guide.")

        app.buttons["Add New Item"].tap()
        XCTAssertEqual(app.tables.cells.count, 2, "There should be 2 list rows after adding an item.")
    }

    func testEditingGuideUpdatesCorrectly() {
        app.buttons["Open"].tap()
        XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")

        app.buttons["Add Guide"].tap()
        XCTAssertEqual(app.tables.cells.count, 1, "There should be 1 list row after adding a guide.")

        app.buttons["Compose"].tap()
        app.textFields["Guide name"].tap()

        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Guides"].tap()

        XCTAssertTrue(
            app.tables.staticTexts["New Guide 2"].exists,
            "The new guide name should be visible in the list."
        )
    }

    func testEditingItemUpdatesCorrectly() {
        // Go to Open Guides and add one guide and one item.
        testAddingItemInsertsRows()

        app.buttons["New Item"].tap()
        app.textFields["Item name"].tap()

        app.keys["space"].tap()
        app.keys["more"].tap()
        app.keys["2"].tap()
        app.buttons["Return"].tap()

        app.buttons["Open Guides"].tap()

        XCTAssertTrue(app.buttons["New Item 2"].exists, "The new item name should be visible in the list.")
    }

    func testAllAwardsShowLockedAlert() {
        app.buttons["Awards"].tap()

        for award in app.scrollViews.buttons.allElementsBoundByIndex {
            award.tap()
            XCTAssertTrue(app.alerts["Locked"].exists, "There should be a Locked alert showing for awards.")
            app.buttons["OK"].tap()
        }
    }
}
