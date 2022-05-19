//
//  GuideSummaryView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 30/04/22.
//

import SwiftUI

struct GuideSummaryView: View {
    @ObservedObject var guide: Guide

    var body: some View {
        VStack(alignment: .leading) {
            Text("\(guide.guideItems.count) items")
                .font(.caption)
                .foregroundColor(.secondary)

            Text(guide.guideTitle)
                .font(.title2)

            ProgressView(value: guide.completionAmount)
                .accentColor(Color(guide.guideColor))
        }
        .padding()
        .background(Color.secondarySystemGroupedBackground)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(guide.label)
    }
}

struct GuideSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        GuideSummaryView(guide: Guide.example)
    }
}
