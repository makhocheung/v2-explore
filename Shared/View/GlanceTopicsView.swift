//
//  LatestTopicsView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import SwiftUI
import V2EXClient

struct GlanceTopicsView: View {
    let topicType: GlanceTopicType
    @State var topics: [Topic] = []
    var appAction = AppContext.shared.appAction

    var body: some View {
        ScrollView {
            ForEach(topics) {
                NavigationLinkView(topic: $0)
            }
        }
        .navigationTitle(LocalizedStringKey("glance." + topicType.rawValue))
        .task {
            #if DEBUG
                topics = debugTopics
            #else
                do {
                    topics = try await V2EXClient.shared.getTopicsByTab(tab: topicType.rawValue)
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
        topics.isEmpty ? AnyView(ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)) : AnyView(EmptyView())
    }
}

#if DEBUG
    struct LatestTopicsView_Previews: PreviewProvider {
        static var previews: some View {
            NavigationView {
                GlanceTopicsView(topicType: GlanceTopicType.qna)
            }
        }
    }
#endif
