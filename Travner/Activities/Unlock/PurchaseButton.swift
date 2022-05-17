//
//  PurchaseButton.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 03/05/22.
//

import SwiftUI

struct PurchaseButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, minHeight: 44)
            .background(Color("Blue"))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .foregroundColor(.white)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .font(.body.bold())
    }
}
