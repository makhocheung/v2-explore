//
//  GeneralView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2023/1/13.
//

import Kingfisher
import SwiftUI

struct GeneralView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack(alignment: .leading) {
            Text("帐号信息")
                .font(.title3)
                .bold()
            
            HStack {
                if let user = appState.user{
                    KFImage(URL(string: user.avatar)!)
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
        }
        .padding()
        .padding(.horizontal)
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
