//
//  TabIcon.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2022/1/8.
//

import SwiftUI

struct TabIcon: View {
    let systemName: String
    let title: String
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: systemName)
                .font(.title2)
            Text(title)
                .font(.footnote)
        }
        .foregroundColor(.accentColor)
    }
}

struct TabIcon_Previews: PreviewProvider {
    static var previews: some View {
        TabIcon(systemName: "house", title: "首页")
    }
}
