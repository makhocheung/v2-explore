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
        VStack {
            if let replies = replies {
                ForEach(replies.indices) { floor in
                    let reply = replies[floor]
                    ReplyView(reply: reply, isOP: topic.member.id == reply.memberId, floor: floor + 1)
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
        }
        .task {
            do {
                replies = try await APIService.shared.getRepliesByTopic(topicId: topic.id)
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
