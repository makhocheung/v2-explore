//
//  SwiftUIView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import Kingfisher
import SwiftUI

struct ProfileView: View {
    @State var cacheSize = "计算中"

    let appVersion: String
    let build: String

    // alert boolean
    @State var isShowCleanCacheAlert = false
    @State var isShowShareAlert = false

    init() {
        let dict = Bundle.main.infoDictionary!
        appVersion = dict["CFBundleShortVersionString"] as? String ?? "0.0"
        build = dict["CFBundleVersion"] as? String ?? "0"
    }

    var body: some View {
        List {
            VStack {
                Image("Icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text("V2 Explore")
                    .font(.title)
            }
            .frame(maxWidth: .infinity)
            .listRowSeparator(.hidden)
            Button {
                isShowCleanCacheAlert.toggle()
            } label: {
                Label("缓存清理", systemImage: "clear.fill")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .confirmationDialog("共 \(cacheSize)，确定要清理缓存吗", isPresented: $isShowCleanCacheAlert, titleVisibility: .visible) {
                Button(role: .destructive) {
                    ImageCache.default.clearDiskCache {
                        cacheSize = "0 MB"
                    }
                } label: {
                    Text("确认")
                }
                Button(role: .cancel) {
                } label: {
                    Text("取消")
                }
            }
            Link(destination: URL(string: "https://github.com/makhocheung/v2-explore")!) {
                Label("GitHub 与反馈", systemImage: "link.circle.fill")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button {
                UIPasteboard.general.url = URL(string: "https://testflight.apple.com/join/SdCh3Wbb")
                isShowShareAlert.toggle()
            } label: {
                Label("分享", systemImage: "square.and.arrow.up.fill")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .alert("已复制分享链接", isPresented: $isShowShareAlert) {
                Text("完成")
            }
            Text("版本：\(appVersion)(build \(build))")
                .font(.footnote)
                .padding()
                .frame(maxWidth: .infinity)
        }
        .listStyle(.plain)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
                .navigationTitle("我的")
        }
    }
}
