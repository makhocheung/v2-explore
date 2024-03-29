//
//  V2EX_YouApp.swift
//  Shared
//
//  Created by Mak Ho-Cheung on 2021/11/23.
//

import SwiftUI

@main
struct V2EXApp: App {
    #if os(macOS)
        @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    #endif

    private let appState = AppState()

    var body: some Scene {
        #if os(macOS)
            Window("V2 Explore", id: "Main") {
                MainView()
                    .environmentObject(appState)
            }
            .windowToolbarStyle(.unified(showsTitle: false))
            .defaultSize(width: 1240, height: 800)
        #else
            WindowGroup {
                MainView()
                    .environmentObject(appState)
            }
        #endif

        #if os(macOS)
            WindowGroup(id: "UserTopics", for: String.self) { value in
                if let username = value.wrappedValue {
                    UserTopicsView(username: username)
                        .environmentObject(AppState())
                }
            }
            .defaultSize(width: 1024, height: 600)
            WindowGroup("发布帖子", id: "PostTopic") {
                PostTopicView()
                    .environmentObject(appState)
            }
            .defaultSize(width: 680, height: 640)
            Settings {
                SettingsView()
                    .environmentObject(appState)
            }
        #endif
    }
}

struct ImageBorderModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(lineWidth: 0.5)
                    .foregroundStyle(.tertiary)
                    .blendMode(colorScheme == .light ? .plusDarker : .plusLighter)
                // RoundedRectangle(cornerRadius: 10, style: .continuous)
                //                        .stroke(.ultraThickMaterial, lineWidth: 1)
                
            }
    }
}

extension View {

    func imageBorder(cornerRadius: CGFloat) -> some View {
        ModifiedContent(content: self, modifier: ImageBorderModifier(cornerRadius: cornerRadius))
    }
}
