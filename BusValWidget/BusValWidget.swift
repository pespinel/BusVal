//
//  BusValWidget.swift
//  BusValWidget
//
//  Created by Pablo on 6/1/22.
//

import CoreData
import SFSafeSymbols
import SwiftUI
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

// MARK: ENTRY
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
        VStack(alignment: .leading, spacing: 1) {
            ForEach(0..<4) { index in
                if favoriteStops.indices.contains(index) {
                    Link(destination: URL(string: "busval://www.auvasa.es/details?code=\(favoriteStops[index].code)")!) {
                        HStack {
                            Image(systemSymbol: .grid)
                                .foregroundColor(Color("AccentColor"))
                                .imageScale(.medium)
                                .font(.body)
                            VStack(alignment: .leading) {
                                Text("Parada \(favoriteStops[index].code)").bold()
                                    .font(.footnote)
                                Text(favoriteStops[index].name)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                    }
                }
            }
            Spacer()
        }.padding()
    }

    private var largeView: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack {
                Image(systemSymbol: .staroflifeCircleFill)
                    .foregroundColor(Color("AccentColor"))
                Text("Paradas favoritas")
                    .font(.headline)
            }.padding([.top, .bottom], 10)
            Divider().padding(.bottom, 5)
            ForEach(0..<9) { index in
                if favoriteStops.indices.contains(index) {
                    Link(destination: URL(string: "busval://www.auvasa.es/details?code=\(favoriteStops[index].code)")!) {
                        HStack {
                            Image(systemSymbol: .grid)
                                .foregroundColor(Color("AccentColor"))
                                .imageScale(.medium)
                                .font(.body)
                            VStack(alignment: .leading) {
                                Text("Parada \(favoriteStops[index].code)").bold()
                                    .font(.footnote)
                                Text(favoriteStops[index].name)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            Spacer()
                        }
                    }
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
