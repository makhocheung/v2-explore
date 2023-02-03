//
//  NotSiginInProfileView.swift
//  V2 Explore (iOS)
//
//  Created by Mak Ho-Cheung on 2023/2/3.
//

import SwiftUI

struct NotSiginInProfileView: View {
    var body: some View {
        List {
            Image("Icon")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text("V2 Explore")
                .font(.title)
            NavigationLink("登录", value: NavigationTag.siginIn)
            NavigationLink("设置", value: NavigationTag.settings)
        }
        .navigationDestination(for: NavigationTag.self) {
            switch $0 {
            case .siginIn:
                SignInView()
            case .settings:
                SettingsView()
            }
        }
    }
}

enum NavigationTag: Hashable {
    case siginIn, settings
}

struct NotSiginInProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NotSiginInProfileView()
    }
}
