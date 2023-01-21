//
//  PostReplyView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2023/1/19.
//

import SwiftUI
import V2EXClient

struct PostReplyView: View {
    let replyObjectInfo: ReplyObjectInfo
    @State var replyContent = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack(alignment: .leading) {
            Text(replyObjectInfo.outline)
                .lineLimit(3)
                .offset(x: 5)
                .padding(3)
                .background(alignment: .leading) {
                    Color.accentColor
                        .opacity(0.8)
                        .frame(width: 2)
                }
            TextEditor(text: $replyContent)
            HStack {
                Spacer()
                Button("回复") {
                    Task {
                        do {
                            try await V2EXClient.shared.reply(id: replyObjectInfo.id, content: replyContent)
                            appState.needRefreshTopic = true
                            dismiss()
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
        .frame(width: 320, height: 240)
        .padding()
        .onAppear {
            if !replyObjectInfo.isReplyTopic {
                replyContent = "@\(replyObjectInfo.username) "
            }
        }
    }
}
