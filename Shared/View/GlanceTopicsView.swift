//
//  LatestTopicsView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import SwiftUI
import V2EXClient

struct GlanceTopicsView: View {
    let node: String
    let title: String
    @State var topics: [Topic] = []
    var appAction = AppContext.shared.appAction

    init(node: String, title: String) {
        self.node = node
        self.title = title
    }

    var body: some View {
        List {
            Section {
                ForEach(topics) {
                    NavigationLinkView(topic: $0)
                }
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .navigationTitle(title)
        .task {
            #if DEBUG
                topics = debugTopics
            #else
                do {
                    topics = try await APIService.shared.getTopicsByNode(nodeName: node)
                } catch {
                    if error.localizedDescription != "cancelled" {
                        print("[v2-explore]: \(error.localizedDescription)")
                        appAction.updateErrorMsg(errorMsg: "网络请求异常")
                        appAction.toggleIsShowErrorMsg()
                    }
                }
            #endif
        }
        .background(bgView)
    }

    var bgView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
struct LatestTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GlanceTopicsView(node: "qna", title: "问与答")
        }
    }
}
#endif
