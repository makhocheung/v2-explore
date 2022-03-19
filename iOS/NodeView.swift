//
//  NodeView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2022/1/23.
//

import Kingfisher
import SwiftUI

struct NodeView: View {
    let node: Node
    @State var topics: [Topic] = []

    var body: some View {
        List {
            VStack(spacing: 10) {
                KFImage(URL(string: node.avatarLarge))
                    .cornerRadius(4)
                Text(node.header ?? "")
                    .fixedSize(horizontal: false, vertical: true)
                HStack {
                    Text("\(node.topics) 个主题")
                    Spacer()
                    Text("\(node.stars) 个收藏")
                }
            }
            .listRowSeparator(.hidden)
            Section {
                ForEach(topics) {
                    NavigationLinkView(topic: $0)
                }
            }
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
        }
        .background(bgView)
        .listStyle(.plain)
        .navigationTitle(node.title)
        .task {
            do {
                topics = try await APIService.shared.getTopicsByNode(nodeName: node.name)
            } catch {
                print("\(error)")
            }
        }
    }

    var bgView: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NodeView(node: nodes[3])
        }
    }
}
