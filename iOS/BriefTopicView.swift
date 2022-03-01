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
        VStack(alignment: .leading) {
            HStack {
                KFImage(URL(string: briefTopic.member.avatarNormal))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .cornerRadius(4)
                VStack(alignment: .leading, spacing: 2) {
                    Text(briefTopic.member.username)
                        .bold()
                    if !briefTopic.lastReplyBy.isEmpty {
                        HStack {
                            Text(timestamp2Date(timestamp: briefTopic.lastTouched))
                            Dot()
                            Text(briefTopic.lastReplyBy)
                                .bold()
                        }
                    } else {
                        Text(timestamp2Date(timestamp: briefTopic.created))
                    }
                }
                Spacer()
                Text(briefTopic.node.name)
                    .padding(5)
                    .background(Color("TagColor"))
                    .cornerRadius(4)
            }
            Spacer()
            Text(briefTopic.title)
                .font(.body)
                .bold()
                .multilineTextAlignment(.leading)
            Spacer()
            HStack(spacing: 0) {
                Spacer()
                Image(systemName: "bubble.right")
                Text(String(briefTopic.replies))
            }
        }
        .font(.caption)
        .foregroundColor(.accentColor)
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
        BriefTopicView(briefTopic: testTopic)
            .preferredColorScheme(.dark)
            .previewLayout(.fixed(width: 400, height: 120))
            .padding()
    }
}
