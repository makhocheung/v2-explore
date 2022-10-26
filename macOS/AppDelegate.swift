//
//  AppDelegate.swift
//  V2 Explore (macOS)
//
//  Created by Mak Ho-Cheung on 2022/10/26.
//

import AppKit
import Foundation

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
