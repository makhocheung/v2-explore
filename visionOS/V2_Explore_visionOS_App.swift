//
//  V2_Explore_visionOS_App.swift
//  V2 Explore(visionOS)
//
//  Created by Mak Ho-Cheung on 2024/3/14.
//

import SwiftUI

@main
struct V2_Explore_visionOS_App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
