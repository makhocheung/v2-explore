//
//  SiginInProfileView.swift
//  V2 Explore (iOS)
//
//  Created by Mak Ho-Cheung on 2023/2/3.
//

import Kingfisher
import SwiftUI

struct SiginInProfileView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            KFImage(URL(string: appState.user!.avatar)!)
                .placeholder({ _ in
                    Circle()
                        .fill(.gray.opacity(0.7))
                        .frame(width: 50, height: 50)
                        .shimmering()
                })
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .clipShape(Circle())
            NavigationLink("设置", value: NavigationTag.settings)
        }
    }
}

struct SiginInProfileView_Previews: PreviewProvider {
    static var previews: some View {
        SiginInProfileView()
    }
}
