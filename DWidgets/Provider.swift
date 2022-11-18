//
//  Provider.swift
//  DWidgetsExtension
//
//  Created by Mak Ho-Cheung on 2022/11/18.
//

import Foundation
import V2EXClient
import WidgetKit

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TopicsEntry {
        TopicsEntry(date: Date.now, topics: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (TopicsEntry) -> Void) {
        let entry = TopicsEntry(date: Date.now, topics: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TopicsEntry>) -> Void) {
        let topicsForWidgets = UserDefaults(suiteName: "group.com.naamfung.widgets")?.data(forKey: "topicsForWidgets")
        var topics: [Topic] = []
        if let topicsForWidgets {
            topics = try! JSONDecoder().decode([Topic].self, from: topicsForWidgets)
        }
        let entry = TopicsEntry(date: Date.now, topics: topics)
        completion(Timeline(entries: [entry], policy: .after(.now + 300)))
    }
}
