//
//  SZView.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import UIKit

class SZView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground // 다크,라이트모드 
        setView()
        setLayout()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /// 뷰에 필요한 설정들 추가
    /// addSubview, 백그라운드 컬러
    func setView() {}
    /// 레이아웃 제약조건 설정
    func setLayout() {}
}
