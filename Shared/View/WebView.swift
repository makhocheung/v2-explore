//
//  WebView.swift
//  V2EX You (iOS)
//
//  Created by Mak Ho-Cheung on 2021/12/11.
//

import SwiftUI
import WebKit

#if os(macOS)
    typealias ViewRespresentable = NSViewRepresentable
#else
    typealias ViewRespresentable = UIViewRepresentable
#endif

struct WebView: ViewRespresentable {
    static let webview = V2EXWebView()
    @Binding var webViewHeight: CGFloat
    var content: String

    #if os(macOS)
    func makeNSView(context: Context) -> WKWebView {
        //WebView.webview.scrollView.bounces = false
        WebView.webview.setValue(false, forKey: "drawsBackground")
        WebView.webview.navigationDelegate = context.coordinator
        WebView.webview.loadHTMLString(content, baseURL: URL(string: "https://v2ex.com"))
        return WebView.webview
    }
    func updateNSView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(content, baseURL: URL(string: "https://v2ex.com"))
    }
    #else
    func makeUIView(context: Context) -> WKWebView {
        WebView.webview.scrollView.bounces = false
        WebView.webview.navigationDelegate = context.coordinator
        WebView.webview.loadHTMLString(content, baseURL: URL(string: "https://v2ex.com"))
        return WebView.webview
    }
    func updateUIView(_ webView: WKWebView, context: Context) {
        WebView.webview.loadHTMLString(content, baseURL: URL(string: "https://v2ex.com"))

    }
    #endif
    

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
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

class V2EXWebView: WKWebView {
    #if os(macOS)
    override func scrollWheel(with event: NSEvent) {
        nextResponder?.scrollWheel(with: event)
    }
    #endif
}
