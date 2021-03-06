//
//  ProductView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 03/05/22.
//

import StoreKit
import SwiftUI

struct ProductView: View {
    @EnvironmentObject var unlockManager: UnlockManager
    let product: SKProduct

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("You can add three guides for free, or pay \(product.localizedPrice) to add unlimited guides.")

            Text("If you already bought the unlock on another device, press Restore Purchases.")

            Spacer()

            VStack(spacing: 20) {
                Button("Buy: \(product.localizedPrice)", action: unlock)
                    .buttonStyle(PurchaseButton())

                Button("Restore Purchases", action: unlockManager.restore)
            }
        }
    }

    func unlock() {
        unlockManager.buy(product: product)
    }
}
