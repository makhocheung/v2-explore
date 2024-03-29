//
//  ReplyView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/10.
//

import Kingfisher
import Shimmer
import SwiftUI
import V2EXClient

struct ReplyView: View {
    var reply: Reply
    var isOP = false
    @EnvironmentObject var appState: AppState
    @State var userProfileSelection: UserProfileSelection?
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    userProfileSelection = UserProfileSelection(username: reply.member.name)
                } label: {
                    KFImage(URL(string: reply.member.avatar!))
                        .placeholder({ _ in
                            Rectangle()
                                .fill(.gray.opacity(0.7))
                                .frame(width: 40, height: 40)
                                .cornerRadius(4)
                                .shimmering()
                        })
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 4, style: .continuous))
                        .imageBorder(cornerRadius: 4)
                }
                .buttonStyle(.plain)
                #if os(macOS)
                    .popover(item: $userProfileSelection) {
                        UserProfileView(username: $0.username, useHomeData: $0.isLoginUser)
                    }
                #endif
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Button {
                            userProfileSelection = UserProfileSelection(username: reply.member.name)
                        } label: {
                            Text(reply.member.name)
                        }
                        .buttonStyle(.plain)

                        if isOP {
                            Text("OP")
                                .padding(2)
                                .foregroundColor(.blue)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.blue, lineWidth: 1)
                                }
                        }
                    }
                    Text(reply.creatTime)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("#\(reply.floor)")
                    .foregroundColor(.secondary)
            }
            Text(reply.content)
                .font(.body)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
    
            HStack {
                Spacer()
                Button {
                    #if os(macOS)
                        appState.replyObjectInfo = ReplyObjectInfo(id: appState.topicSelection!, username: reply.member.name, isReplyTopic: false, outline: reply.content)
                    #endif
                } label: {
                    Image(systemName: "arrowshape.turn.up.left")
                }
                .buttonStyle(.plain)
                HStack(spacing: 2) {
                    Button {
                    } label: {
                        Image(systemName: "heart")
                    }
                    .buttonStyle(.plain)
                    Text("\(reply.thankCount)")
                }
            }
            .font(.callout)
        }
        .font(.caption)
    }
}
