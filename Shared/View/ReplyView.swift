//
//  ReplyView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/10.
//

import Kingfisher
import SwiftUI
import V2EXClient

struct ReplyView: View {
    var reply: Reply
    var isOP = false
    var floor = 1
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            HStack {
                Button {
                    appState.userProfileSelection = UserProfileSelection(username: reply.member.name)
                } label: {
                    KFImage(URL(string: reply.member.avatar!))
                        .placeholder({ _ in
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                        })
                        .fade(duration: 0.25)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .cornerRadius(4)
                }
                .buttonStyle(.plain)
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Button {
                            appState.userProfileSelection = UserProfileSelection(username: reply.member.name)
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
                Text("#\(floor)")
                    .foregroundColor(.secondary)
            }
            Text(reply.attributeStringContent)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .font(.caption)
    }
}
