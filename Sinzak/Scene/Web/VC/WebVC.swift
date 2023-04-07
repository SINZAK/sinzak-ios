//
//  WebVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/12.
//

import UIKit
import WebKit

final class WebVC: SZVC {
    var destinationURL: String = ""
    
    lazy var web: WKWebView = {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        let webView = WKWebView(
            frame: view.bounds,
            configuration: configuration
        )
        webView.backgroundColor = CustomColor.background
        
        return webView
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = CustomColor.label
        indicator.isHidden = true
        
        return indicator
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let url = URL(string: destinationURL) else { return }
        let request = URLRequest(url: url)
        
        // TODO: 메인에서 하면안돼??
        // 참고 https://developer.apple.com/forums/thread/712074
        self.web.load(request)
    }
    
    override func configure() {
        web.navigationDelegate = self
        configureLayout()
    }
    
    override func setNavigationBar() {
        super.setNavigationBar()
    }
}

private extension WebVC {
    func configureLayout() {
        [
            web,
            indicator
        ].forEach { view.addSubview($0) }
        
        web.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicator.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

extension WebVC: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        didCommit navigation: WKNavigation!
    ) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: Error
    ) {
        indicator.stopAnimating()
        indicator.isHidden = true
        Log.error(String(describing: error))
    }
}
