//
//  BusValWidget.swift
//  BusValWidget
//
//  Created by Pablo on 6/1/22.
//

import Intents
import SFSafeSymbols
import SwiftUI
import UIKit
import WidgetKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        @FetchRequest(
            entity: FavoriteStop.entity(),
            sortDescriptors: []
        )
        var favoriteStops: FetchedResults<FavoriteStop>

        var entries: [SimpleEntry] = []

        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct BusValWidgetEntryView: View {
    @Environment(\.widgetFamily) var family

    @FetchRequest(
        entity: FavoriteStop.entity(),
        sortDescriptors: []
    )

    var favoriteStops: FetchedResults<FavoriteStop>

    var entry: Provider.Entry

    @ViewBuilder
    var body: some View {
        if favoriteStops.isEmpty {
            Text("Aún no has añadido ninguna parada favorita")
                .padding()
        } else {
            switch family {
            case .systemSmall:
                VStack(alignment: .leading) {
                    ForEach(0..<2) { index in
                        Link(destination: URL(string: "busval://www.auvasa.es/details?code=\(favoriteStops[index].code)")!) {
                            HStack {
                                Image(
                                    systemSymbol: .grid)
                                    .foregroundColor(Color(UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.00)))
                                    .imageScale(.small)
                                    .font(.body)
                                    .foregroundColor(Color.accentColor)
                                VStack(alignment: .leading) {
                                    Text("Parada \(favoriteStops[index].code)").bold()
                                        .font(.footnote)
                                    Text(favoriteStops[index].name)
                                        .font(.caption)
                                }
                                Spacer()
                            }.padding([.bottom])
                        }
                    }
                }.padding()
            case .systemMedium:
                    VStack(alignment: .leading) {
                        ForEach(0..<3) { index in
                            Link(destination: URL(string: "busval://www.auvasa.es/details?code=\(favoriteStops[index].code)")!) {
                                HStack {
                                    Image(
                                        systemSymbol: .grid)
                                        .foregroundColor(
                                            Color(UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.00))
                                        )
                                        .imageScale(.small)
                                        .font(.body)
                                        .foregroundColor(Color.accentColor)
                                    VStack(alignment: .leading) {
                                        Text("Parada \(favoriteStops[index].code)").bold()
                                            .font(.footnote)
                                        Text(favoriteStops[index].name)
                                            .font(.caption)
                                    }
                                    Spacer()
                                }
                            }
                        }
                    }.padding()
            case .systemLarge, .systemExtraLarge:
                ForEach(favoriteStops) { stop in
                    Link(destination: URL(string: "busval://www.auvasa.es/details?code=\(stop.code)")!) {
                        HStack {
                            Image(
                                systemSymbol: .grid)
                                .foregroundColor(Color(UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.00)))
                                .imageScale(.small)
                                .font(.body)
                                .foregroundColor(Color.accentColor)
                            VStack(alignment: .leading) {
                                Text("Parada \(stop.code)").bold()
                                    .font(.footnote)
                                Text(stop.name)
                                    .font(.caption)
                            }
                            Spacer()
                        }
                    }
                }.padding()
            @unknown default:
                fatalError("Switch family is not supported")
            }
        }
    }
}

@main
struct BusValWidget: Widget {
    let kind: String = "BusValWidget"
    let persistenceController = PersistenceController.shared

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BusValWidgetEntryView(entry: entry)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .configurationDisplayName("BusValWidget")
        .description("Accede de forma rápida a tus paradas favoritas")
    }
}

#if DEBUG
struct BusValWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        BusValWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct BusValWidgetMedium_Previews: PreviewProvider {
    static var previews: some View {
        BusValWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

struct BusValWidgetLarge_Previews: PreviewProvider {
    static var previews: some View {
        BusValWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

struct BusValWidgetExtraLarge_Previews: PreviewProvider {
    static var previews: some View {
        BusValWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
#endif
