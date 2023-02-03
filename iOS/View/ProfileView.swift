//
//  SwiftUIView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import Kingfisher
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        if appState.user != nil {
            SiginInProfileView()
        } else {
            NotSiginInProfileView()
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
