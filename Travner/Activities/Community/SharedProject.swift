//
//  SharedGuide.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 07/05/22.
//

import Foundation

struct SharedGuide: Identifiable {
    let id: String
    let title: String
    let detail: String
    let owner: String
    let closed: Bool

    static let example = SharedGuide(id: "1", title: "Example", detail: "Detail", owner: "mazzalins", closed: false)
}
