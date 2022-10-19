//
//  ShowStore.swift
//  V2 Explore
//
//  Created by Mak Ho-Cheung on 2022/3/20.
//

import Foundation
import V2EXClient

class AppState : ObservableObject {
    
    @Published var isShowErrorMsg = false
    @Published var errorMsg = ""
    @Published var isShowTips = false
    @Published var tips = ""
    let navigationNodes = try! V2EXClient.shared.getNavigatinNodes()
}
