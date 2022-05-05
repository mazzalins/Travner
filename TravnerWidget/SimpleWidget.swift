//
//  SimpleWidget.swift
//  TravnerWidgetExtension
//
//  Created by Lorenzo Lins Mazzarotto on 05/05/22.
//

import SwiftUI
import WidgetKit

struct TravnerWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Up next…")
                .font(.title)

            if let item = entry.items.first {
                Text(item.itemTitle)
            } else {
                Text("Nothing!")
            }
        }
    }
}

struct SimpleTravnerWidget: Widget {
    let kind: String = "SimpleTravnerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TravnerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Up next…")
        .description("Your #1 top-priority item.")
        .supportedFamilies([.systemSmall])
    }
}

struct SimpleTravnerWidget_Previews: PreviewProvider {
    static var previews: some View {
        TravnerWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
