//
//  RepliesView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/10.
//

import SwiftUI

struct RepliesView: View {
    var topic: Topic
    @State var replies: [Reply]?
    var body: some View {
        LazyVStack {
            if let replies = replies {
                ForEach(replies.indices) { floor in
                    let reply = replies[floor]
                    ReplyView(reply: reply, isOP: topic.member.id == reply.memberId, floor: floor + 1)
                }
            } else {
                ProgressView()
            }
        }
        .task {
            do {
                let url = URL(string: "https://www.v2ex.com/api/replies/show.json?topic_id=\(topic.id)&time=\(Date().timeIntervalSince1970)")!
                let (data, _) = try await URLSession.shared.data(from: url)
                replies = try JSONDecoder().decode([Reply].self, from: data)
            } catch {
                print("\(error)")
            }
        }
    }
}

struct RepliesView_Previews: PreviewProvider {
    static var previews: some View {
        RepliesView(topic: testTopic)
    }
}
