//
//  HomeViewModel.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 02/05/22.
//

import CoreData
import Foundation

extension HomeView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        private let guidesController: NSFetchedResultsController<Guide>
        private let itemsController: NSFetchedResultsController<Item>

        @Published var guides = [Guide]()
        @Published var items = [Item]()
        @Published var selectedItem: Item?

        var dataController: DataController

        @Published var upNext = ArraySlice<Item>()
        @Published var moreToExplore = ArraySlice<Item>()

        init(dataController: DataController) {
            self.dataController = dataController

            // Construct a fetch request to show all open guides.
            let guideRequest: NSFetchRequest<Guide> = Guide.fetchRequest()
            guideRequest.predicate = NSPredicate(format: "closed = false")
            guideRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Guide.title, ascending: true)]

            guidesController = NSFetchedResultsController(
                fetchRequest: guideRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            // Construct a fetch request to show the 10 highest-priority,
            // incomplete items from open guides.
            let itemRequest = dataController.fetchRequestForTopItems(count: 10)

            itemsController = NSFetchedResultsController(
                fetchRequest: itemRequest,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()

            guidesController.delegate = self
            itemsController.delegate = self

            do {
                try guidesController.performFetch()
                try itemsController.performFetch()
                guides = guidesController.fetchedObjects ?? []
                items = itemsController.fetchedObjects ?? []

                upNext = items.prefix(3)
                moreToExplore = items.dropFirst(3)
            } catch {
                print("Failed to fetch initial data.")
            }
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            items = itemsController.fetchedObjects ?? []

            upNext = items.prefix(3)
            moreToExplore = items.dropFirst(3)

            guides = guidesController.fetchedObjects ?? []
        }

        func addSampleData() {
            dataController.deleteAll()
            try? dataController.createSampleData()
        }

        func selectItem(with identifier: String) {
            selectedItem = dataController.item(with: identifier)
        }
    }
}
