//
//  GuideHeaderView.swift
//  Travner
//
//  Created by Lorenzo Lins Mazzarotto on 28/04/22.
//

import SwiftUI

struct GuideHeaderView: View {
    @ObservedObject var guide: Guide

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(guide.guideTitle)

                ProgressView(value: guide.completionAmount)
                    .accentColor(Color(guide.guideColor))
            }

            Spacer()

            NavigationLink(destination: EditGuideView(guide: guide)) {
                Image(systemName: "square.and.pencil")
                    .imageScale(.large)
            }
        }
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
    }
}

struct GuideHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        GuideHeaderView(guide: Guide.example)
    }
}
