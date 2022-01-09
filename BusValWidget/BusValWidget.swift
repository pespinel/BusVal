//
//  BusValWidget.swift
//  BusValWidget
//
//  Created by Pablo on 6/1/22.
//

import CoreData
import Intents
import SFSafeSymbols
import SwiftUI
import UIKit
import WidgetKit

// MARK: PROVIDER
struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = Entry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = Entry(date: Date(), configuration: configuration)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

// MARK: TIMELINE
struct Entry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

// MARK: MAIN
@main
struct BusValWidget: Widget {
    let kind: String = "BusValWidget"
    let persistenceController = PersistenceController.shared

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BusValWidgetEntryView(entry: entry)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
        .configurationDisplayName("Favoritos")
        .description("Accede de forma rápida a tus paradas favoritas")
    }
}

// MARK: ENTRYVIEW
struct BusValWidgetEntryView: View {
    @Environment(\.widgetFamily) var family

    static var getFavoriteStopsFetchRequest: NSFetchRequest<FavoriteStop> {
        let request: NSFetchRequest<FavoriteStop> = FavoriteStop.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "code", ascending: true, selector: #selector(NSString.localizedStandardCompare))
        ]
        return request
   }

    @FetchRequest(fetchRequest: getFavoriteStopsFetchRequest)
    var favoriteStops: FetchedResults<FavoriteStop>

    var entry: Provider.Entry

    @ViewBuilder
    var body: some View {
        if favoriteStops.isEmpty {
            emptyView
        } else {
            switch family {
            case .systemSmall:
                smallView.widgetURL(URL(string: "busval://www.auvasa.es/details"))
            case .systemMedium:
                smallView
            case .systemLarge, .systemExtraLarge:
                largeView
            @unknown default:
                fatalError("Widget family is not supported")
            }
        }
    }
}

// MARK: COMPONENTS
extension BusValWidgetEntryView {
    private var emptyView: some View {
        Text("Aún no has añadido ninguna parada favorita")
            .font(.body)
            .padding()
    }

    private var smallView: some View {
        VStack(alignment: .leading) {
            ForEach(0..<4) { index in
                if favoriteStops.indices.contains(index) {
                    Link(destination: URL(string: "busval://www.auvasa.es/details?code=\(favoriteStops[index].code)")!) {
                        HStack {
                            Image(systemSymbol: .grid)
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
                                    .lineLimit(1)
                            }
                            Spacer()
                        }.padding(0.5)
                    }
                }
            }
            Spacer()
        }.padding()
    }

    private var largeView: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemSymbol: .staroflifeFill)
                    .foregroundColor(.accentColor)
                Text("Favoritos")
                    .font(.headline)
            }
            ForEach(favoriteStops) { stop in
                Link(destination: URL(string: "busval://www.auvasa.es/details?code=\(stop.code)")!) {
                    HStack {
                        Image(systemSymbol: .grid)
                            .foregroundColor(
                                Color(UIColor(red: 0.15, green: 0.68, blue: 0.38, alpha: 1.00))
                            )
                            .imageScale(.small)
                            .font(.body)
                            .foregroundColor(Color.accentColor)
                        VStack(alignment: .leading) {
                            Text("Parada \(stop.code)").bold()
                                .font(.footnote)
                            Text(stop.name)
                                .font(.caption)
                                .lineLimit(1)
                        }
                        Spacer()
                    }.padding(0.5)
                }
            }
            Spacer()
        }.padding()
    }
}

// MARK: PREVIEWS
#if DEBUG
struct BusValWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared
        return BusValWidgetEntryView(entry: Entry(date: Date(), configuration: ConfigurationIntent()))
            .previewDevice("iPhone 13 Pro")
            .environment(\.managedObjectContext, context.container.viewContext)
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}

struct BusValWidgetMedium_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared
        return BusValWidgetEntryView(entry: Entry(date: Date(), configuration: ConfigurationIntent()))
            .previewDevice("iPhone 13 Pro")
            .environment(\.managedObjectContext, context.container.viewContext)
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

struct BusValWidgetLarge_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared
        return BusValWidgetEntryView(entry: Entry(date: Date(), configuration: ConfigurationIntent()))
            .previewDevice("iPhone 13 Pro")
            .environment(\.managedObjectContext, context.container.viewContext)
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}

struct BusValWidgetExtraLarge_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared
        return BusValWidgetEntryView(entry: Entry(date: Date(), configuration: ConfigurationIntent()))
            .previewDevice("iPhone 13 Pro")
            .environment(\.managedObjectContext, context.container.viewContext)
            .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
    }
}
#endif
