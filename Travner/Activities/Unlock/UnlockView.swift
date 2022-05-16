//
//  UnlockView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 03/05/22.
//

import StoreKit
import SwiftUI

struct UnlockView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var unlockManager: UnlockManager

    var body: some View {
        NavigationView {
            Group {
                switch unlockManager.requestState {
                case .loaded(let product):
                    ProductView(product: product)
                case .failed:
                    Text("Sorry, there was an error loading the store. Please try again later.")
                case .loading:
                    ProgressView("Loading…")
                case .purchased:
                    Text("Thank you!")
                case .deferred:
                    // swiftlint:disable:next line_length
                    Text("Thank you! Your request is pending approval, but you can carry on using the app in the meantime.")
                }
            }
            .padding()
            .navigationBarTitle("All Access Package")
            .toolbar {
                Button(action: dismiss, label: {
                    Circle()
                        .fill(Color(.secondarySystemBackground))
                        .frame(width: 30, height: 30)
                        .overlay(
                            Image(systemName: "xmark")
                                .font(.system(size: 12, weight: .heavy, design: .rounded))
                                .foregroundColor(.secondary)
                        )
                })
            }
            .onReceive(unlockManager.$requestState) { value in
                if case .purchased = value {
                    dismiss()
                }
            }
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
