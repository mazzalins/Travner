//
//  SKProduct-LocalizedPrice.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 03/05/22.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
