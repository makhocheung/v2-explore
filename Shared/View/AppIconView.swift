//
//  AppIconView.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2023/2/3.
//

import SwiftUI

struct AppIconView: View {
    let size: Double
    var body: some View {
        Image("signInIcon")
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
    }
}

struct AppIconView_Previews: PreviewProvider {
    static var previews: some View {
        AppIconView(size: 64)
    }
}
