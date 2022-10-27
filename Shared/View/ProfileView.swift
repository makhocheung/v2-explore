//
//  SwiftUIView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import Kingfisher
import SwiftUI

#if os(macOS)
typealias PasteBoard = NSPasteboard
#elseif os(iOS)
typealias PasteBoard = UIPasteboard
#endif
struct ProfileView: View {
    @State var cacheSize = "..."

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
            //.listRowSeparator(.hidden)
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
//                PasteBoard.general.url = URL(string: "https://testflight.apple.com/join/SdCh3Wbb")
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
                //.listRowSeparator(.hidden)
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

#if DEBUG
    struct ProfileView_Previews: PreviewProvider {
        static var previews: some View {
            ProfileView()
                .navigationTitle("我的")
        }
    }
#endif
