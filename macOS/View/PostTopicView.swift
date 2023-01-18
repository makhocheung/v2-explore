//
//  PostTopicView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2023/1/18.
//

import SwiftUI
import V2EXClient

struct PostTopicView: View {
    @EnvironmentObject var appState: AppState
    @State var title = ""
    @State var nodeSelection: Node?
    @State var content = ""
    @State var postSuccess = false
    var body: some View {
        VStack(alignment: .leading) {
            if !postSuccess {
                HStack {
                    Text("标题：")
                    TextField("", text: $title)
                        .textFieldStyle(.plain)
                }
                Divider()
                Picker("节点：", selection: $nodeSelection) {
                }
                .frame(width: 200)
                TextEditor(text: $content)
            } else {
                Text("发布成功！")
            }
        }
        .padding()
        .toolbar {
            ToolbarItem {
                Button {
                    let tocpi = PostTopic(title: title, content: content, nodeName: "apple")
                    Task {
                        do {
                            let id = try await V2EXClient.shared.postTopic(topic: tocpi)
                            postSuccess = true
                        } catch {
                        }
                    }
                } label: {
                    Image(systemName: "paperplane")
                }
            }
        }
    }
}

struct PostTopicView_Previews: PreviewProvider {
    static var previews: some View {
        PostTopicView()
    }
}
