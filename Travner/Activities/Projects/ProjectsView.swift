//
//  GuidesView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 27/04/22.
//

import SwiftUI

struct GuidesView: View {
    static let openTag: String? = "Open"
    static let closedTag: String? = "Closed"

    @StateObject var viewModel: ViewModel
    @State private var showingSortOrder = false

    var guidesList: some View {
        List {
            ForEach(viewModel.guides) { guide in
                Section(header: GuideHeaderView(guide: guide)) {
                    ForEach(guide.guideItems(using: viewModel.sortOrder)) { item in
                        ItemRowView(guide: guide, item: item)
                    }
                    .onDelete { offsets in
                        viewModel.delete(offsets, from: guide)
                    }

                    if viewModel.showClosedGuides == false {
                        Button {
                            withAnimation {
                                viewModel.addItem(to: guide)
                            }
                        } label: {
                            Label("Add New Item", systemImage: "plus")
                        }
                    }
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }

    var addGuideToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            if viewModel.showClosedGuides == false {
                Button {
                    withAnimation {
                        viewModel.addGuide()
                    }
                } label: {
                    Label("Add Guide", systemImage: "plus")
                }
            }
        }
    }

    var sortOrderToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                showingSortOrder.toggle()
            } label: {
                Label("Sort", systemImage: "arrow.up.arrow.down")
            }
        }
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.guides.isEmpty {
                    Text("There's nothing here right now")
                        .foregroundColor(.secondary)
                } else {
                    guidesList
                }
            }
            .navigationTitle(viewModel.showClosedGuides ? "Closed Guides" : "Open Guides")
            .toolbar {
                addGuideToolbarItem
                sortOrderToolbarItem
            }
            .actionSheet(isPresented: $showingSortOrder) {
                ActionSheet(title: Text("Sort items"), message: nil, buttons: [
                    .default(Text("Optimized")) { viewModel.sortOrder = .optimized },
                    .default(Text("Creation Date")) { viewModel.sortOrder = .creationDate },
                    .default(Text("Title")) { viewModel.sortOrder = .title },
                    .cancel()
                ])
            }

            SelectSomethingView()
        }
        .sheet(isPresented: $viewModel.showingUnlockView) {
            UnlockView()
        }
    }

    init(dataController: DataController, showClosedGuides: Bool) {
        let viewModel = ViewModel(dataController: dataController, showClosedGuides: showClosedGuides)
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct GuidesView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        GuidesView(dataController: DataController.preview, showClosedGuides: false)
    }
}
