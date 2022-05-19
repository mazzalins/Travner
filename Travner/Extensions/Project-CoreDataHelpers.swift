//
//  Guide-CoreDataHelpers.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 27/04/22.
//

import CloudKit
import SwiftUI

extension Guide {
    static let colors = [
        "Red",
        "Orange",
        "Yellow",
        "Green",
        "Mint",
        "Teal",
        "Cyan",
        "Blue",
        "Indigo",
        "Purple",
        "Pink",
        "Brown"
    ]

    var guideTitle: String {
        title ?? NSLocalizedString("New Guide", comment: "Create a new guide")
    }

    var guideDetail: String {
        detail ?? ""
    }

    var guideColor: String {
        color ?? "Blue"
    }

    var guideItems: [Item] {
        items?.allObjects as? [Item] ?? []
    }

    var guideItemsDefaultSorted: [Item] {
        guideItems.sorted { first, second in
            if first.completed == false {
                if second.completed == true {
                    return true
                }
            } else if first.completed == true {
                if second.completed == false {
                    return false
                }
            }

            if first.priority > second.priority {
                return true
            } else if first.priority < second.priority {
                return false
            }

            return first.itemCreationDate < second.itemCreationDate
        }
    }

    var completionAmount: Double {
        let originalItems = items?.allObjects as? [Item] ?? []
        guard originalItems.isEmpty == false else { return 0 }

        let completedItems = originalItems.filter(\.completed)
        return Double(completedItems.count) / Double(originalItems.count)
    }

    var label: LocalizedStringKey {
        // swiftlint:disable:next line_length
        LocalizedStringKey("\(guideTitle), \(guideItems.count) items, \(completionAmount * 100, specifier: "%g")% complete.")
    }

    static var example: Guide {
        let controller = DataController.preview
        let viewContext = controller.container.viewContext

        let guide = Guide(context: viewContext)
        guide.title = "Example Guide"
        guide.detail = "This is an example guide"
        guide.closed = true
        guide.creationDate = Date()
        return guide
    }

    func guideItems(using sortOrder: Item.SortOrder) -> [Item] {
        switch sortOrder {
        case .title:
            return guideItems.sorted(by: \Item.itemTitle)
        case .creationDate:
            return guideItems.sorted(by: \Item.itemCreationDate)
        case .optimized:
            return guideItemsDefaultSorted
        }
    }

    func prepareCloudRecords(owner: String) -> [CKRecord] {
        let parentName = objectID.uriRepresentation().absoluteString
        let parentID = CKRecord.ID(recordName: parentName)
        let parent = CKRecord(recordType: "Guide", recordID: parentID)
        parent["title"] = guideTitle
        parent["detail"] = guideDetail
        parent["owner"] = owner
        parent["closed"] = closed

        var records = guideItemsDefaultSorted.map { item -> CKRecord in
            let childName = item.objectID.uriRepresentation().absoluteString
            let childID = CKRecord.ID(recordName: childName)
            let child = CKRecord(recordType: "Item", recordID: childID)
            child["title"] = item.itemTitle
            child["detail"] = item.itemDetail
            child["completed"] = item.completed
            child["guide"] = CKRecord.Reference(recordID: parentID, action: .deleteSelf)
            return child
        }

        records.append(parent)
        return records
    }

    func checkCloudStatus(_ completion: @escaping (Bool) -> Void) {
        let name = objectID.uriRepresentation().absoluteString
        let id = CKRecord.ID(recordName: name)
        let operation = CKFetchRecordsOperation(recordIDs: [id])
        operation.desiredKeys = ["recordID"]

        operation.fetchRecordsCompletionBlock = { records, _ in
            if let records = records {
                completion(records.count == 1)
            } else {
                completion(false)
            }
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }
}
