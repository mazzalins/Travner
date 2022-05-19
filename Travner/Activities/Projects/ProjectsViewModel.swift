//
//  GuidesViewModel.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 02/05/22.
//

import CoreData
import Foundation

extension GuidesView {
    class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
        let dataController: DataController

        var sortOrder = Item.SortOrder.optimized
        let showClosedGuides: Bool

        private let guidesController: NSFetchedResultsController<Guide>
        @Published var guides = [Guide]()

        @Published var showingUnlockView = false

        init(dataController: DataController, showClosedGuides: Bool) {
            self.dataController = dataController
            self.showClosedGuides = showClosedGuides

            let request: NSFetchRequest<Guide> = Guide.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(keyPath: \Guide.creationDate, ascending: false)]
            request.predicate = NSPredicate(format: "closed = %d", showClosedGuides)

            guidesController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: dataController.container.viewContext,
                sectionNameKeyPath: nil,
                cacheName: nil
            )

            super.init()
            guidesController.delegate = self

            do {
                try guidesController.performFetch()
                guides = guidesController.fetchedObjects ?? []
            } catch {
                print("Failed to fetch guides")
            }
        }

        func addGuide() {
            if dataController.addGuide() == false {
                showingUnlockView.toggle()
            }
        }

        func addItem(to guide: Guide) {
            let item = Item(context: dataController.container.viewContext)
            item.guide = guide
            item.priority = 2
            item.completed = false
            item.creationDate = Date()
            dataController.save()
        }

        func delete(_ offsets: IndexSet, from guide: Guide) {
            let allItems = guide.guideItems(using: sortOrder)

            for offset in offsets {
                let item = allItems[offset]
                dataController.delete(item)
            }

            dataController.save()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            if let newGuides = controller.fetchedObjects as? [Guide] {
                guides = newGuides
            }
        }
    }
}
