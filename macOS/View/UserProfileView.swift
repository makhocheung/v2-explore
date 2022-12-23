//
//  UserProfileView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/12/21.
//

import Kingfisher
import SwiftUI
import V2EXClient

struct UserProfileView: View {
    let username: String
    let useHomeData: Bool
    @State var user: User?
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    var body: some View {
        VStack {
            if let user {
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    HStack {
                        KFImage(URL(string: user.avatar)!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .clipShape(Circle())
                        VStack(alignment: .leading) {
                            HStack {
                                Text(user.name)
                                    .font(.title)
                                if let activityRank = user.activityRank {
                                    Text("今日活跃度排名 \(activityRank)")
                                        .font(.caption)
                                        .foregroundColor(.accentColor)
                                        .padding(5)
                                        .background(.gray.opacity(0.5))
                                        .cornerRadius(8)
                                }
                            }
                            if let memberDesc = user.memberDesc {
                                Text(memberDesc)
                                    .foregroundColor(.gray)
                            }
                            if let favoriteNodeCount = user.favoriteNodeCount,
                               let favoriteTopicCount = user.favoriteTopicCount,
                               let followerCount = user.followerCount {
                                HStack {
                                    Text("节点收藏：\(favoriteNodeCount)")
                                        .padding(5)
                                        .background(.regularMaterial)
                                        .cornerRadius(8)
                                    Text("主题收藏：\(favoriteTopicCount)")
                                        .padding(5)
                                        .background(.regularMaterial)
                                        .cornerRadius(8)
                                    Text("特别关注：\(followerCount)")
                                        .padding(5)
                                        .background(.regularMaterial)
                                        .cornerRadius(8)
                                }
                                .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                    }
                    Divider()
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Button {
                            } label: {
                                Label("查看主题", systemImage: "newspaper")
                            }

                            Button {
                                openURL(URL(string: "https://v2ex.com/member/\(username)")!)
                            } label: {
                                Label("浏览器中打开", systemImage: "safari")
                            }
                            .help("info.help.openInBrowser")

                            if useHomeData {
                                Button {
                                } label: {
                                    Label("登出", systemImage: "rectangle.portrait.and.arrow.right")
                                }
                            }
                        }
                        .foregroundColor(.accentColor)
                        .buttonStyle(.plain)
                        Spacer()
                    }
                    Spacer()
                }
                .padding()
            } else {
                ProgressView()
            }
        }
        .frame(width: 420, height: 250)
        .background(.regularMaterial)
        .task {
            do {
                user = try await V2EXClient.shared.getUserProfile(name: username, useHomeData: useHomeData)
                print(user)
            } catch {
                print(error)
            }
        }
    }
}
