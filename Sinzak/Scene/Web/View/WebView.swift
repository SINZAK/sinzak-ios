//
//  WebView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/12.
//

import UIKit
import SnapKit
import Then
import WebKit

final class WebView: SZView {
    let web = WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
    let indicator = UIActivityIndicatorView().then {
        $0.tintColor = CustomColor.red!
    }
    
    override func setView() {
        super.setView()
        addSubviews(web, indicator)
    }
    override func setLayout() {
        web.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        indicator.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
}
