//
//  ContentView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 27/04/22.
//

import CoreSpotlight
import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedView") var selectedView: String?
    @EnvironmentObject var dataController: DataController

    private let newGuideActivity = "dev.mazzalins.Travner.newGuide"

    var body: some View {
        TabView(selection: $selectedView) {
            HomeView(dataController: dataController)
                .tag(HomeView.tag)
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }

            GuidesView(dataController: dataController, showClosedGuides: false)
                .tag(GuidesView.openTag)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("Open")
                }

            GuidesView(dataController: dataController, showClosedGuides: true)
                .tag(GuidesView.closedTag)
                .tabItem {
                    Image(systemName: "checkmark")
                    Text("Closed")
                }

            AwardsView()
                .tag(AwardsView.tag)
                .tabItem {
                    Image(systemName: "rosette")
                    Text("Awards")
                }

            SharedGuidesView()
                .tag(SharedGuidesView.tag)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Community")
                }
        }
        .onContinueUserActivity(CSSearchableItemActionType, perform: moveToHome)
        .onContinueUserActivity(newGuideActivity, perform: createGuide)
        .userActivity(newGuideActivity) { activity in
            activity.isEligibleForPrediction = true
            activity.title = "New Guide"
        }
        .onOpenURL(perform: openURL)
    }

    func moveToHome(_ input: Any) {
        selectedView = HomeView.tag
    }

    func openURL(_ url: URL) {
        selectedView = GuidesView.openTag
        dataController.addGuide()
    }

    func createGuide(_ userActivity: NSUserActivity) {
        selectedView = GuidesView.openTag
        dataController.addGuide()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var dataController = DataController.preview

    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, dataController.container.viewContext)
            .environmentObject(dataController)
    }
}
