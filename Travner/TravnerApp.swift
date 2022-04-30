//
//  TravnerApp.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 27/04/22.
//

import SwiftUI

@main
struct TravnerApp: App {
    @StateObject var dataController: DataController

    init() {
        let dataController = DataController()
        _dataController = StateObject(wrappedValue: dataController)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .onReceive(
                    // Automatically save when we detect that we are
                    // no longer the foreground app. Use this rather than
                    // scene phase so we can port to macOS, where scene
                    // phase won't detect our app losing focus.
                    NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification),
                    perform: save
                )
        }
    }

    func save(_ note: Notification) {
        dataController.save()
    }
}
