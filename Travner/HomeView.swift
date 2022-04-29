//
//  HomeView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 27/04/22.
//

import CoreData
import SwiftUI

struct HomeView: View {
    static let tag: String? = "Home"
    
    @EnvironmentObject var dataController: DataController

    @FetchRequest(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)], predicate: NSPredicate(format: "closed = false")) var projects: FetchedResults<Project>
    let items: FetchRequest<Item>

    init() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "completed = false")

        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \Item.priority, ascending: false)
        ]

        request.fetchLimit = 10
        items = FetchRequest(fetchRequest: request)
    }

    var body: some View {
        NavigationView {
            ScrollView {

            }
            .background(Color.systemGroupedBackground.ignoresSafeArea())
            .navigationTitle("Home")
        }
    }
}

//Button("Add Data") {
//    dataController.deleteAll()
//    try? dataController.createSampleData()
//}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
