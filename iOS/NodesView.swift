//
//  NodesView.swift
//  V2EX You
//
//  Created by Mak Ho-Cheung on 2021/12/8.
//

import SwiftUI

struct NodesView: View {
    var body: some View {
        List(0 ..< 100, id: \.self) {
            Text(String($0))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("RootBackgroundColor"))
    }
}

struct NodesView_Previews: PreviewProvider {
    static var previews: some View {
        NodesView()
    }
}
