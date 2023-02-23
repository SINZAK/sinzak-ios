//
//  UIView+UIStackView+Extension.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/26.
//

import UIKit

extension UIView {
    /// 여러개의 뷰를 서브뷰로 한번에 추가합니다.
    func addSubviews(_ views: UIView...) {
        views.forEach { self.addSubview($0) }
    }
}

extension UIStackView {
    /// 여러개의 뷰를 스택뷰의 서브뷰로 한번에 추가합니다.
    func addArrangedSubviews(_ views: UIView...) {
        for view in views { addArrangedSubview(view) }
    }
}
