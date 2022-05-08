//
//  DataController-StoreKit.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 05/05/22.
//

import Foundation
import StoreKit

extension DataController {
    func appLaunched() {
        guard count(for: Project.fetchRequest()) >= 5 else { return }

        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first

        if let windowScene = scene as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
