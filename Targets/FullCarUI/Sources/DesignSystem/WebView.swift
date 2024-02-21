//
//  WebView.swift
//  FullCarUI
//
//  Created by Sunny on 2/21/24.
//  Copyright © 2024 FullCar Corp. All rights reserved.
//

import SwiftUI
import WebKit

public struct WebView: UIViewRepresentable {
    var url: String

    public init(url: String) {
        self.url = url
    }

    public func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }

        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    public func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebView>) { }
}
