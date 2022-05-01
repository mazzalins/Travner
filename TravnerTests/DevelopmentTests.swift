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

        XCTAssertEqual(dataController.count(for: Project.fetchRequest()), 5, "There should be 5 sample projects.")
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 50, "There should be 50 sample items.")
    }
}
