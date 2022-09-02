//
//  TopicItemView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import Kingfisher
import SwiftUI
import V2EXClient

struct SimpleTopicView: View {
    @Environment(\.colorScheme) var colorScheme
    let topic: Topic
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                KFImage(URL(string: topic.member.avatar!))
                    .placeholder({ _ in
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    })
                    .fade(duration: 0.25)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .cornerRadius(4)
                VStack(alignment: .leading, spacing: 2) {
                    Text(topic.member.name)
                        .foregroundColor(.primary)
                    if let lastReplyBy = topic.lastReplyBy {
                        HStack {
                            Text(topic.lastTouched!)
                            Dot()
                            Text(lastReplyBy.name)
                        }
                    } else {
                        Text(topic.createTime!)
                    }
                }
                Spacer()
                Text("#\(topic.node.title)")
            }
            .foregroundColor(.secondary)
            Text(topic.title)
                .multilineTextAlignment(.leading)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 0) {
                Spacer()
                Image(systemName: "bubble.right")
                Text(String(topic.replyCount!))
            }
        }
        .font(.caption)
        .foregroundColor(.primary)
    }
}

struct Dot: View {
    var body: some View {
        Circle()
            .foregroundColor(.secondary)
            .frame(width: 5, height: 5)
    }
}

#if DEBUG
    struct TopicItemView_Previews: PreviewProvider {
        static var previews: some View {
            Group {
                SimpleTopicView(topic: debugTopic)
                    .previewLayout(.fixed(width: 400, height: 120))
                    .padding()
                SimpleTopicView(topic: debugTopic)
                    .preferredColorScheme(.dark)
                    .previewLayout(.fixed(width: 400, height: 120))
                    .padding()
            }
        }
    }
#endif
