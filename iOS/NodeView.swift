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
    @State var showError = false

    var body: some View {
        VStack(spacing: 10) {
            KFImage(URL(string: node.avatarLarge))
                .cornerRadius(4)
            Text(node.header ?? "")
            HStack {
                Text("\(node.topics) 个主题")
                Spacer()
                Text("\(node.stars) 个收藏")
            }
            .padding(.horizontal)
            VStack {
                ForEach(0 ..< topics.count, id: \.self) { index in
                    if index == 0 {
                        Divider()
                    }
                    NavigationLinkView(topic: topics[index])
                    Divider()
                }
            }
            .background(bgView)
            .alert("获取或解析数据出错", isPresented: $showError) {
                Text("完成")
            }
            .task {
                do {
                    topics = try await APIService.shared.getTopicsByNode(nodeName: node.name)
                } catch {
                    print("\(error)")
                    showError.toggle()
                }
            }
        }
        .foregroundColor(.accentColor)
        .frame(maxHeight: .infinity, alignment: .top)
        .background(Color("RootBackgroundColor"))
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle(node.title)
    }

    var bgView: some View {
        topics.isEmpty ? AnyView(ProgressView()) : AnyView(Color("ContentBackgroundColor"))
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NodeView(node: nodes[3])
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}
