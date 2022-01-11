//
//  Provider.swift
//  BusValWidgetExtension
//
//  Created by Pablo on 11/1/22.
//

import WidgetKit

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> Entry {
        Entry(date: Date(), configuration: ConfigurationIntent(), family: context.family)
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Entry) -> Void) {
        let entry = Entry(date: Date(), configuration: configuration, family: context.family)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entry = Entry(date: Date(), configuration: configuration, family: context.family)
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}
