//
//  TravnerWidget.swift
//  TravnerWidget
//
//  Created by Lorenzo Lins Mazzarotto on 05/05/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), items: [Item.example])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), items: loadItems())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = SimpleEntry(date: Date(), items: loadItems())
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }

    func loadItems() -> [Item] {
        let dataController = DataController()
        let itemRequest = dataController.fetchRequestForTopItems(count: 5)
        return dataController.results(for: itemRequest)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let items: [Item]
}

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

struct TravnerWidgetMultipleEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.sizeCategory) var sizeCategory

    var entry: Provider.Entry

    var items: ArraySlice<Item> {
        let itemCount: Int

        switch widgetFamily {
        case .systemSmall:
            itemCount = 1
        case .systemLarge:
            if sizeCategory < .extraExtraLarge {
                itemCount = 5
            } else {
                itemCount = 4
            }
        default:
            if sizeCategory < .extraLarge {
                itemCount = 3
            } else {
                itemCount = 2
            }
        }

        return entry.items.prefix(itemCount)
    }

    var body: some View {
        VStack(spacing: 5) {
            ForEach(items) { item in
                HStack {
                    Color(item.project?.color ?? "Light Blue")
                        .frame(width: 5)
                        .clipShape(Capsule())

                    VStack(alignment: .leading) {
                        Text(item.itemTitle)
                            .font(.headline)
                            .layoutPriority(1)

                        if let projectTitle = item.project?.projectTitle {
                            Text(projectTitle)
                                .foregroundColor(.secondary)
                        }
                    }

                    Spacer()
                }
            }
        }
        .padding(20)
    }
}

@main
struct TravnerWidgets: WidgetBundle {
    var body: some Widget {
        SimpleTravnerWidget()
        ComplexTravnerWidget()
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

struct ComplexTravnerWidget: Widget {
    let kind: String = "ComplexTravnerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TravnerWidgetMultipleEntryView(entry: entry)
        }
        .configurationDisplayName("Up next…")
        .description("Your most important items.")
    }
}

struct TravnerWidget_Previews: PreviewProvider {
    static var previews: some View {
        TravnerWidgetEntryView(entry: SimpleEntry(date: Date(), items: [Item.example]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
