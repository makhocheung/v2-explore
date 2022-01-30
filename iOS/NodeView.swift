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
                        let url = URL(string: "https://www.v2ex.com/api/topics/show.json?node_id=\(node.id)&time=\(Date().timeIntervalSince1970)")!
                        let (data, _) = try await URLSession.shared.data(from: url)
                        topics = try JSONDecoder().decode([Topic].self, from: data)
                        done()
                    } catch {
                        print("\(error)")
                        // showError.toggle()
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
                    let url = URL(string: "https://www.v2ex.com/api/topics/show.json?node_id=\(node.id)&time=\(Date().timeIntervalSince1970)")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    topics = try JSONDecoder().decode([Topic].self, from: data)
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
        .confirmationDialog("是否将节点加入到首页", isPresented: $showAlert,titleVisibility: .visible) {
            Button(role: .destructive) {
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
