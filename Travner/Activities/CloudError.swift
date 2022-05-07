//
//  CloudError.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 07/05/22.
//

import SwiftUI

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
    var id: String { message }
    var message: String

    var localizedMessage: LocalizedStringKey {
        LocalizedStringKey(message)
    }

    init(stringLiteral value: String) {
        self.message = value
    }
}
