//
//  RepliesView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/10.
//

import SwiftUI
import V2EXClient

struct RepliesView: View {
    var topic: Topic
    @State var replies: [Reply]?
    var appAction = AppContext.shared.appAction
    var body: some View {
        Section {
            if let replies = replies {
                ForEach(replies.indices) { floor in
                    let reply = replies[floor]
                    VStack {
                        ReplyView(reply: reply, isOP: topic.member.id == reply.memberId, floor: floor + 1)
                        Divider()
                    }
                    .padding(.top, 10)
                }
            } else {
                ProgressView()
                    .frame(maxWidth: .infinity)
            }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        .task {
            #if DEBUG
                replies = debugReplies
            #else
                do {
                    replies = try await APIService.shared.getRepliesByTopic(topicId: topic.id)
                } catch {
                    if error.localizedDescription != "cancelled" {
                        print("[v2-explore]: \(error.localizedDescription)")
                        appAction.updateErrorMsg(errorMsg: "网络请求异常")
                        appAction.toggleIsShowErrorMsg()
                    }
                }
            #endif
        }
    }
}

#if DEBUG
struct RepliesView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            RepliesView(topic: debugTopic)
        }
    }
}
#endif
