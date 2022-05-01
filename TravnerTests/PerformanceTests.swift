//
//  PerformanceTests.swift
//  TravnerTests
//
//  Created by Lorenzo Lins Mazzarotto on 01/05/22.
//

import XCTest
@testable import Travner

class PerformanceTests: BaseTestCase {
    func testAwardCalculationPerformance() throws {
        try dataController.createSampleData()
        let awards = Award.allAwards

        measure {
            _ = awards.filter(dataController.hasEarned)
        }
    }
}
