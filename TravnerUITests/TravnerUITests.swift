//
//  TravnerUITests.swift
//  TravnerUITests
//
//  Created by Lorenzo Lins Mazzarotto on 01/05/22.
//

import XCTest

class TravnerUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testExample() throws {
        let app = XCUIApplication()
        app.launchArguments = ["enable-testing"]
        app.launch()
    }
}
