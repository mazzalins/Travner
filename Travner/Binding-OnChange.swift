//
//  Binding-OnChange.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 28/04/22.
//

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
