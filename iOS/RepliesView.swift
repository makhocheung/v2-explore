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
    @State var errorStore = AppStore.errorStore
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
        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        .task {
            do {
                replies = try await APIService.shared.getRepliesByTopic(topicId: topic.id)
            } catch {
                if error.localizedDescription != "cancelled" {
                    print("[v2-explore]: \(error.localizedDescription)")
                    errorStore.errorMsg = "网络请求异常"
                    errorStore.isShowError.toggle()
                }
            }
        }
    }
}

struct RepliesView_Previews: PreviewProvider {
    static var previews: some View {
        RepliesView(topic: testTopic)
    }
}
