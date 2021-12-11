//
//  WebView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    static let webview = WKWebView()
    @Binding var webViewHeight: CGFloat
    var content: String

    func makeUIView(context: Context) -> WKWebView {
        WebView.webview.scrollView.bounces = false
        WebView.webview.navigationDelegate = context.coordinator
        WebView.webview.loadHTMLString(content, baseURL: URL(string: "https://v2ex.com"))
        return WebView.webview
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.scrollHeight", completionHandler: { height, _ in
                DispatchQueue.main.async {
                    self.parent.webViewHeight = height as! CGFloat
                }
            })
        }
    }
}
