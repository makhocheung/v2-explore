//
//  DWidgets.swift
//  DWidgets
//
//  Created by Mak Ho-Cheung on 2022/11/18.
//

import Kingfisher
import SwiftUI
import V2EXClient
import WidgetKit

struct DWidgetsEntryView: View {
    var entry: TopicsEntry

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("V2 Explore 最新")
                    .padding(.bottom)
                    .bold()
                Spacer()
            }
            if entry.topics.isEmpty {
                Text("当前没有帖子")
            } else {
                ForEach(entry.topics) { topic in
                    Link(destination: URL(string: "v2ex://topic/\(topic.id)")!) {
                        Text(topic.title)
                            .lineLimit(1)
                    }
                    Divider()
                }
            }
        }
        .padding()
    }
}

@main
struct DWidgets: Widget {
    let kind: String = "DWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DWidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("V2 Explore")
        .description("最新帖子")
        .supportedFamilies([.systemSmall])
    }
}

struct DWidgets_Previews: PreviewProvider {
    static var previews: some View {
        DWidgetsEntryView(entry: TopicsEntry(date: .now, topics: []))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
