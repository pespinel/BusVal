//
//  BusValWidgetView.swift
//
//  Created by Pablo on 11/1/22.
//

import CoreData
import SFSafeSymbols
import SwiftUI
import WidgetKit

// MARK: - BusValWidgetView

struct BusValWidgetView: View {
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
            switch entry.family {
            case .systemSmall:
                smallView.widgetURL(URL(string: "busval://www.auvasa.es/details"))
            case .systemMedium:
                smallView
            case .systemExtraLarge, .systemLarge:
                largeView
            case .accessoryCircular:
                fatalError("Widget family is not supported")
            case .accessoryRectangular:
                fatalError("Widget family is not supported")
            case .accessoryInline:
                fatalError("Widget family is not supported")
            @unknown default:
                fatalError("Widget family is not supported")
            }
        }
    }
}

// MARK: Components

extension BusValWidgetView {
    private var emptyView: some View {
        Text("Aún no has añadido ninguna parada favorita")
            .font(.body)
            .padding()
    }

    private var smallView: some View {
        VStack(alignment: .leading, spacing: 1) {
            ForEach(0 ..< 4) { index in
                if favoriteStops.indices.contains(index) {
                    Link(
                        destination: URL(string: "busval://www.auvasa.es/details?code=\(favoriteStops[index].code)")!
                    ) {
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
            ForEach(0 ..< 9) { index in
                if favoriteStops.indices.contains(index) {
                    Link(
                        destination: URL(string: "busval://www.auvasa.es/details?code=\(favoriteStops[index].code)")!
                    ) {
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

// MARK: - BusValWidgetView_Previews

#if DEBUG
    struct BusValWidgetView_Previews: PreviewProvider {
        static var previews: some View {
            let context = PersistenceController.shared
            return Group {
                BusValWidgetView(
                    entry: Entry(
                        date: Date(),
                        configuration: ConfigurationIntent(),
                        family: .systemSmall
                    )
                )
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.managedObjectContext, context.container.viewContext)
                BusValWidgetView(
                    entry: Entry(
                        date: Date(),
                        configuration: ConfigurationIntent(),
                        family: .systemMedium
                    )
                )
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.managedObjectContext, context.container.viewContext)
                BusValWidgetView(
                    entry: Entry(
                        date: Date(),
                        configuration: ConfigurationIntent(),
                        family: .systemLarge
                    )
                )
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .environment(\.managedObjectContext, context.container.viewContext)
                BusValWidgetView(
                    entry: Entry(
                        date: Date(),
                        configuration: ConfigurationIntent(),
                        family: .systemExtraLarge
                    )
                )
                .previewContext(WidgetPreviewContext(family: .systemExtraLarge))
                .environment(\.managedObjectContext, context.container.viewContext)
            }
        }
    }
#endif
