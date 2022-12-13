//
//  setFont.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import UIKit

enum SpoqaHanSansStyle: String {
    case regular = "SpoqaHanSansNeo-Regular"
    case medium = "SpoqaHanSansNeo-Medium"
    case bold = "SpoqaHanSansNeo-Bold"
}

extension UIFont {
    // Title
    static var subtitle_B: UIFont { customFont(SpoqaHanSansStyle.bold.rawValue, size: 16)}
    // Body
    static var body_B: UIFont  {
        customFont(SpoqaHanSansStyle.bold.rawValue, size: 16) }
    static var body_M: UIFont  { customFont(SpoqaHanSansStyle.medium.rawValue, size: 16) }
    static var body_R: UIFont  { customFont(SpoqaHanSansStyle.regular.rawValue, size: 16) }
    
    // Caption
    static var caption_B: UIFont  { customFont(SpoqaHanSansStyle.bold.rawValue, size: 13) }
    static var caption_M: UIFont  { customFont(SpoqaHanSansStyle.medium.rawValue, size: 13) }
    static var caption_R: UIFont  { customFont(SpoqaHanSansStyle.regular.rawValue, size: 13) }
    
    /// 커스텀 폰트를 설정하는 메서드
    private static func customFont(
        _ name: String, size: CGFloat,
        style: UIFont.TextStyle? = nil,
        scaled: Bool = false ) -> UIFont {
            guard let font = UIFont(name: name, size: size) else {
                print("Warning: Font '\(name)' not found.")
                return UIFont.systemFont(ofSize: size, weight: .regular)
            }
            
            if scaled, let style = style {
                let metrics = UIFontMetrics(forTextStyle: style)
                return metrics.scaledFont(for: font)
            } else {
                return font
            }
        }
}
