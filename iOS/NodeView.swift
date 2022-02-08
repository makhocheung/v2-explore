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
    @State var showAlert = false
    @StateObject var preferNodesState = PreferNodesState.shared

    var body: some View {
        VStack(spacing: 10) {
            KFImage(URL(string: node.avatarLarge))
                .cornerRadius(4)
            Text(node.title)
                .font(.title)
                .bold()
            Text(node.header ?? "")
            HStack {
                Text("\(node.topics) 个主题")
                Spacer()
                Text("\(node.stars) 个收藏")
            }
            .padding(.horizontal)
            RefreshableScrollView { done in
                Task {
                    do {
                        topics = try await APIService.shared.getTopics(PreferNode(title: node.title, id: node.id))
                        done()
                    } catch {
                        print("\(error)")
                        showError.toggle()
                    }
                }
            } content: {
                VStack {
                    ForEach(0 ..< topics.count, id: \.self) { index in
                        if index == 0 {
                            Divider()
                        }
                        NavigationLinkView(topic: topics[index])
                        Divider()
                    }
                }
            }
            .background(bgView)
            .alert("获取或解析数据出错", isPresented: $showError) {
                Text("完成")
            }
            .task {
                do {
                    topics = try await APIService.shared.getTopics(PreferNode(title: node.title, id: node.id))
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
        .toolbar {
            ToolbarItem {
                Button {
                    showAlert.toggle()
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
        }
        .navigationTitle("")
        .confirmationDialog("是否将节点加入到首页", isPresented: $showAlert, titleVisibility: .visible) {
            Button(role: .destructive) {
                preferNodesState.tmpPreferNodes.append(SimplePreferNode(id: node.id, title: node.title))
                PreferNodesState.savePreferNodes()
            } label: {
                Text("确认")
            }
            Button(role: .cancel) {
            } label: {
                Text("取消")
            }
        }
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
