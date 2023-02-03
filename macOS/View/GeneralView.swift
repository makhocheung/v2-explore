//
//  GeneralView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2023/1/13.
//

import Kingfisher
import SwiftUI
import Shimmer

struct GeneralView: View {
    @EnvironmentObject var appState: AppState
    @State var appearance = Appearance.system
    @State var cacheSize = "..."
    @State var isShowCleanCacheAlert = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("帐号信息")
                .font(.title3)
                .bold()

            HStack {
                if let user = appState.user {
                    KFImage(URL(string: user.avatar)!)
                        .placeholder({ _ in
                            Circle()
                                .fill(.gray.opacity(0.7))
                                .frame(width: 60, height: 60)
                                .shimmering()
                        })
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    Text(user.name)
                        .font(.headline)
                    Spacer()
                    Button("登出") {
                        appState.signOut()
                    }
                } else {
                    Image(systemName: "person.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                    Spacer()
                    Button("登录") {
                        appState.isShowLoginView = true
                    }
                }
            }
            Divider()
            Text("外观")
                .font(.title3)
                .bold()
            Picker("选择", selection: $appearance) {
                Text("跟随系统")
                    .tag(Appearance.system)
                Text("浅色模式")
                    .tag(Appearance.light)
                Text("深色模式")
                    .tag(Appearance.dark)
            }
            .frame(width: 200)
            Divider()
            Text("存储空间")
                .font(.title3)
                .bold()
            HStack {
                Text(cacheSize)
                    .padding(.top, 2)
                Spacer()
                Button {
                    isShowCleanCacheAlert.toggle()
                } label: {
                    Label("info.clearCache", systemImage: "clear.fill")
                }
                .confirmationDialog("info.clearCacheTips \(cacheSize)", isPresented: $isShowCleanCacheAlert, titleVisibility: .visible) {
                    Button(role: .destructive) {
                        ImageCache.default.clearDiskCache {
                            cacheSize = "0 MB"
                        }
                    } label: {
                        Text("common.confirm")
                    }
                    Button(role: .cancel) {
                    } label: {
                        Text("common.cancel")
                    }
                }
            }
        }
        .padding()
        .padding(.horizontal)
        .onAppear {
            ImageCache.default.calculateDiskStorageSize { result in
                switch result {
                case let .success(size):
                    cacheSize = String(format: "%.1f MB", Double(size) / 1024 / 1024)
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}

enum Appearance {
    case system, light, dark
}
