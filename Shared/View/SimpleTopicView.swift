//
//  TopicItemView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import Kingfisher
import V2EXClient
import SwiftUI

struct SimpleTopicView: View {
    @Environment(\.colorScheme) var colorScheme
    let briefTopic: Topic
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                KFImage(URL(string: briefTopic.member.avatar!))
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
                    Text(briefTopic.member.name)
                    if let lastReplyBy = briefTopic.lastReplyBy {
                        HStack {
                            Text(briefTopic.lastTouched!)
                            Dot()
                            Text(lastReplyBy.name)
                        }
                        .foregroundColor(.secondary)
                    } else {
                        Text(briefTopic.createTime!)
                        .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Text(briefTopic.node.title)
                .padding(5)
                .background(Color("TagColor"))
                .cornerRadius(4)
            }
            Text(briefTopic.title)
            .multilineTextAlignment(.leading)
            .font(.body)
            .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 0) {
                Spacer()
                Image(systemName: "bubble.right")
                Text(String(briefTopic.replyCount!))
            }
        }
        .font(.caption)
        .foregroundColor(.primary)
    }
}

struct Dot: View {
    var body: some View {
        Circle()
        .foregroundColor(.gray)
        .frame(width: 5, height: 5)
    }
}

#if DEBUG
struct TopicItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SimpleTopicView(briefTopic: debugTopic)
            .previewLayout(.fixed(width: 400, height: 120))
            .padding()
            SimpleTopicView(briefTopic: debugTopic)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 400, height: 120))
            .padding()
        }
    }
}
#endif
