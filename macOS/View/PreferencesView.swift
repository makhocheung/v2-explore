//
//  PreferencesView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/11/25.
//

import Kingfisher
import SwiftUI

struct PreferencesView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        TabView {
            accountView
                .tabItem {
                    Image(systemName: "person.circle")
                }
        }
        .frame(width: 400)
    }

    @ViewBuilder
    var accountView: some View {
        if let user = appState.user {
            KFImage(URL(string: user.avatar)!)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .clipShape(Circle())
        } else {
            Button {
                appState.isShowLoginView.toggle()
            } label: {
                ZStack {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                        Text("common.signIn")
                    }
                }
                .frame(height: 50)
            }
            .buttonStyle(.borderless)
        }
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView()
    }
}
