//
//  WebVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/12.
//

import UIKit
import WebKit

final class WebVC: SZVC {
    let mainView = WebView()
    var destinationURL: String = ""
    // MARK: - Lifecycle
    override func loadView() {
        view = mainView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func configure() {
        mainView.indicator.isHidden = true
        mainView.web.navigationDelegate = self
        openWebpage(destinationURL)
    }
    override func setNavigationBar() {
        super.setNavigationBar()
    }
}
extension WebVC: WKNavigationDelegate {
    func openWebpage(_ url: String ) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        mainView.web.load(request)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        mainView.indicator.isHidden = false
        mainView.indicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        mainView.indicator.stopAnimating()
        mainView.indicator.isHidden = true
    }
}
