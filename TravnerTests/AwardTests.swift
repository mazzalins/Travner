//
//  AwardTests.swift
//  TravnerTests
//
//  Created by Lorenzo Lins Mazzarotto on 01/05/22.
//

import CoreData
import XCTest
@testable import Travner

class AwardTests: BaseTestCase {
    let awards = Award.allAwards

    func testAwardIDMatchesName() {
        for award in awards {
            XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
        }
    }

    func testNoAwards() throws {
        for award in awards {
            XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards")
        }
    }
}
