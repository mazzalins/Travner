//
//  DevelopmentTests.swift
//  TravnerTests
//
//  Created by Lorenzo Lins Mazzarotto on 01/05/22.
//

import CoreData
import XCTest
@testable import Travner

class DevelopmentTests: BaseTestCase {
    func testSampleDataCreationWorks() throws {
        try dataController.createSampleData()

        XCTAssertEqual(dataController.count(for: Guide.fetchRequest()), 5, "There should be 5 sample guides.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "There should be 50 sample items.")
    }

    func testDeleteAllClearsEverything() throws {
        try dataController.createSampleData()
        dataController.deleteAll()

        XCTAssertEqual(dataController.count(for: Guide.fetchRequest()), 0, "deleteAll() should leave 0 guides.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 0, "deleteAll() should leave 0 items.")
    }

    func testExampleGuideIsClosed() {
        let guide = Guide.example
        XCTAssertTrue(guide.closed, "The example guide should be closed.")
    }

    func testExampleItemIsHighPriority() {
        let item = Item.example
        XCTAssertEqual(item.priority, 3, "The example item should be high priority.")
    }
}
