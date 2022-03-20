//
//  ShowStore.swift
//  V2 Explore
//
//  Created by Mak Ho-Cheung on 2022/3/20.
//

import Foundation

class ErrorStore : ObservableObject {
    
    @Published var isShowError = false
    @Published var errorMsg = ""
}
