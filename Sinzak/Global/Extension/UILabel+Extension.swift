//
//  UILabel+Extension.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/28.
//

import UIKit

extension UILabel {
    /// 행간 높이를 추가하는 메서드
    func addInterlineSpacing(spacing: CGFloat = 2) {

        // MARK: - 텍스트 존재 여부 확인
        guard let textString = text else { return }

        // MARK: - 텍스트를 "NSMutableAttributedString" 으로 바꾸기
        let attributedString = NSMutableAttributedString(string: textString)

        // MARK: -  "NSMutableParagraphStyle" 인스턴스 생성
        let paragraphStyle = NSMutableParagraphStyle()

        // MARK: -  ParagraphStyle 에 스페이싱을 추가
        paragraphStyle.lineSpacing = spacing

        // MARK: - ParagraphStyle을  attributed String에 추가
        attributedString.addAttribute(
            .paragraphStyle,
            value: paragraphStyle,
            range: NSRange(location: 0, length: attributedString.length
        ))

        // MARK: - Attributed Text에 수정한 문자열을 배속
        attributedText = attributedString
    }

}
