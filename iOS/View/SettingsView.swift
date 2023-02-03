//
//  SettingsView.swift
//  V2 Explore (iOS)
//
//  Created by Mak Ho-Cheung on 2023/2/3.
//

import SwiftUI
import Kingfisher

struct SettingsView: View {
    @State var cacheSize = "..."
    @State var isShowCleanCacheAlert = false
    @State var isShowShareAlert = false

    let appVersion: String
    let build: String

    init() {
        let dict = Bundle.main.infoDictionary!
        appVersion = dict["CFBundleShortVersionString"] as! String
        build = dict["CFBundleVersion"] as? String ?? "0"
    }

    var body: some View {
        List {
            Button {
                isShowCleanCacheAlert.toggle()
            } label: {
                Label("info.clearCache", systemImage: "clear.fill")
                    .frame(maxWidth: .infinity, alignment: .leading)
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
            Link(destination: URL(string: "https://github.com/makhocheung/v2-explore")!) {
                Label("info.githubFeedback", systemImage: "link.circle.fill")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Button {
                UIPasteboard.general.url = URL(string: "https://testflight.apple.com/join/SdCh3Wbb")
                isShowShareAlert.toggle()
            } label: {
                Label("common.share", systemImage: "square.and.arrow.up.fill")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .alert("info.copy.link", isPresented: $isShowShareAlert) {
                Text("common.cancel")
            }
            Text("info.version \(appVersion) \(build)")
                .font(.footnote)
                .padding()
                .frame(maxWidth: .infinity)
            Text("")
                .font(.footnote)
                .frame(maxWidth: .infinity)
            // .listRowSeparator(.hidden)
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
