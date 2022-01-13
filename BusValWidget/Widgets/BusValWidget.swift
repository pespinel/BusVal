//
//  BusValWidget.swift
//  BusValWidget
//
//  Created by Pablo on 6/1/22.
//

import SwiftUI
import WidgetKit

// MARK: MAIN

@main
struct BusValWidget: Widget {
    let kind: String = "BusValWidget"
    let persistenceController = PersistenceController.shared

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            BusValWidgetView(entry: entry)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge])
        .configurationDisplayName("Favoritos")
        .description("Accede de forma rápida a tus paradas favoritas")
    }
}
