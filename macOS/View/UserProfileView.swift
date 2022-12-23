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
    var body: some View {
        ZStack {
            if let user {
                UserProfileContentView(user: user)
                    .font(.body)
            } else {
                ProgressView()
            }
        }
        .frame(width: 420, height: 250)
        .task {
            do {
                user = try await V2EXClient.shared.getUserProfile(name: username, useHomeData: useHomeData)
            } catch {
                print(error)
            }
        }
    }
}
