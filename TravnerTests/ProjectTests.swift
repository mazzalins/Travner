//
//  GuideTests.swift
//  TravnerTests
//
//  Created by Lorenzo Lins Mazzarotto on 01/05/22.
//

import CoreData
import XCTest
@testable import Travner

class GuideTests: BaseTestCase {
    func testCreatingGuidesAndItems() {
        let targetCount = 10

        for _ in 0..<targetCount {
            let guide = Guide(context: managedObjectContext)

            for _ in 0..<targetCount {
                let item = Item(context: managedObjectContext)
                item.guide = guide
            }
        }

        XCTAssertEqual(dataController.count(for: Guide.fetchRequest()), targetCount)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), targetCount * targetCount)
    }

    func testDeletingGuideCascadeDeletesItems() throws {
        try dataController.createSampleData()

        let request = NSFetchRequest<Guide>(entityName: "Guide")
        let guides = try managedObjectContext.fetch(request)

        dataController.delete(guides[0])

        XCTAssertEqual(dataController.count(for: Guide.fetchRequest()), 4)
        XCTAssertEqual(dataController.count(for: Item.fetchRequest()), 40)
    }
}
