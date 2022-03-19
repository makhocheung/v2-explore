//
//  ShowStore.swift
//  V2 Explore
//
//  Created by Mak Ho-Cheung on 2022/3/20.
//

import Foundation

class AppState : ObservableObject {
    
    @Published var isShowErrorMsg = false
    @Published var errorMsg = ""
}
