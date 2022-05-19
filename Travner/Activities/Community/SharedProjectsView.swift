//
//  SharedGuidesView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 07/05/22.
//

import CloudKit
import SwiftUI

struct SharedGuidesView: View {
    static let tag: String? = "Community"

    @State private var guides = [SharedGuide]()
    @State private var loadState = LoadState.inactive

    var body: some View {
        NavigationView {
            Group {
                switch loadState {
                case .inactive, .loading:
                    ProgressView()
                case .noResults:
                    Text("No results")
                case .success:
                    List(guides) { guide in
                        NavigationLink(destination: SharedItemsView(guide: guide)) {
                            VStack(alignment: .leading) {
                                Text(guide.title)
                                    .font(.headline)
                                Text(guide.owner)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                }
            }
            .navigationTitle("Shared Guides")
        }
        .onAppear(perform: fetchSharedGuides)
    }

    func fetchSharedGuides() {
        guard loadState == .inactive else { return }
        loadState = .loading

        let pred = NSPredicate(value: true)
        let sort = NSSortDescriptor(key: "creationDate", ascending: false)
        let query = CKQuery(recordType: "Guide", predicate: pred)
        query.sortDescriptors = [sort]

        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["title", "detail", "owner", "closed"]
        operation.resultsLimit = 50

        operation.recordFetchedBlock = { record in
            let id = record.recordID.recordName
            let title = record["title"] as? String ?? "No title"
            let detail = record["detail"] as? String ?? ""
            let owner = record["owner"] as? String ?? "No owner"
            let closed = record["closed"] as? Bool ?? false

            let sharedGuide = SharedGuide(id: id, title: title, detail: detail, owner: owner, closed: closed)
            guides.append(sharedGuide)
            loadState = .success
        }

        operation.queryCompletionBlock = { _, _ in
            if guides.isEmpty {
                loadState = .noResults
            }
        }

        CKContainer.default().publicCloudDatabase.add(operation)
    }
}

struct SharedGuidesView_Previews: PreviewProvider {
    static var previews: some View {
        SharedGuidesView()
    }
}
