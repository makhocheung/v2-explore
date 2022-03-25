//
//  NodeView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2022/1/23.
//

import Kingfisher
import SwiftUI
import V2EXClient

struct NodeView: View {
    let node: Node
    @State var topics: [Topic] = []
    var appAction = AppContext.shared.appAction

    var body: some View {
        List {
            VStack(spacing: 10) {
                KFImage(URL(string: node))
                    .placeholder({ _ in
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                    })
                    .fade(duration: 0.25)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                Text(node.title ?? "")
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Text("\(node.topics) 个主题")
                        .padding(5)
                        .background(Color("TagColor"))
                        .cornerRadius(5)
                    Spacer()
                    Text("\(node.stars) 个收藏")
                        .padding(5)
                        .background(Color("TagColor"))
                        .cornerRadius(5)
                }
            }
            .listRowSeparator(.hidden)
            Section {
                ForEach(topics) {
                    NavigationLinkView(topic: $0)
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
        .background(bgView)
        .listStyle(.plain)
        .navigationTitle(node.title)
        .task {
            do {
                #if DEBUG
                    topics = debugTopics
                #else
                    topics = try await APIService.shared.getTopicsByNode(nodeName: node.name)
                #endif
            } catch {
                if error.localizedDescription != "cancelled" {
                    print("[v2-explore]: \(error.localizedDescription)")
                    appAction.updateErrorMsg(errorMsg: "网络请求异常")
                    appAction.toggleIsShowErrorMsg()
                }
            }
        }
    }

    var bgView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#if DEBUG
struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NodeView(node: nodes[3])
        }
    }
}
#endif
