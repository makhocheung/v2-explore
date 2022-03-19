//
//  TopicItemView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import Kingfisher
import SwiftUI

struct BriefTopicView: View {
    @Environment(\.colorScheme) var colorScheme
    let briefTopic: Topic
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                KFImage(URL(string: briefTopic.member.avatarNormal))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .cornerRadius(4)
                VStack(alignment: .leading, spacing: 2) {
                    Text(briefTopic.member.username)
                    if !briefTopic.lastReplyBy.isEmpty {
                        HStack {
                            Text(timestamp2Date(timestamp: briefTopic.lastTouched))
                            Dot()
                            Text(briefTopic.lastReplyBy)
                        }
                        .foregroundColor(.secondary)
                    } else {
                        Text(timestamp2Date(timestamp: briefTopic.created))
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Text(briefTopic.node.name)
                    .padding(5)
                    .background(Color("TagColor"))
                    .cornerRadius(4)
            }
            Text(briefTopic.title)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 0) {
                Spacer()
                Image(systemName: "bubble.right")
                Text(String(briefTopic.replies))
            }
        }
        .font(.caption)
    }
}

struct Dot: View {
    var body: some View {
        Circle()
            .foregroundColor(.gray)
            .frame(width: 5, height: 5)
    }
}

struct TopicItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            BriefTopicView(briefTopic: testTopic)
                .previewLayout(.fixed(width: 400, height: 120))
                .padding()
            BriefTopicView(briefTopic: testTopic)
                .preferredColorScheme(.dark)
                .previewLayout(.fixed(width: 400, height: 120))
                .padding()
        }
    }
}
