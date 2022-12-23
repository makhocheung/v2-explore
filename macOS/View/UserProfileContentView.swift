//
//  UserProfileContentView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2023/1/13.
//

import Kingfisher
import SwiftUI
import V2EXClient

struct UserProfileContentView: View {
    let user: User
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @Environment(\.openWindow) var openWindow
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            KFImage(URL(string: user.avatar)!)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            HStack(spacing: 5) {
                Text(user.name)
                    .font(.title)
                    .bold()
                if let activityRank = user.activityRank {
                    Text("今日活跃度排名 \(activityRank)")
                        .font(.caption)
                        .foregroundColor(.accentColor)
                }
            }
            Divider()
            Text("描述")
                .font(.title3)
                .bold()
            Text(user.memberDesc ?? "无")
            if let favoriteNodeCount = user.favoriteNodeCount,
               let favoriteTopicCount = user.favoriteTopicCount,
               let followerCount = user.followerCount {
                Text("收藏")
                    .font(.title3)
                    .bold()
                HStack {
                    Text("节点收藏：\(favoriteNodeCount)")
                    Text("主题收藏：\(favoriteTopicCount)")
                    Text("特别关注：\(followerCount)")
                }
            }
            Spacer()
            HStack {
                Button {
                    openWindow(id: "UserTopics", value: user.name)
                } label: {
                    Label("查看主题", systemImage: "newspaper")
                }

                Button {
                    openURL(URL(string: "https://v2ex.com/member/\(user.name)")!)
                } label: {
                    Label("浏览器中打开", systemImage: "safari")
                }
                .help("info.help.openInBrowser")
            }
        }
        .padding()
    }
}
