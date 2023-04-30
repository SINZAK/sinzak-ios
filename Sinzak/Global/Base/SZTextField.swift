//
//  SZTextField.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/30.
//

import UIKit

class SZTextField: UITextField {
    // MARK: - Properties
    let insets: UIEdgeInsets
    // MARK: - Initialiser
    init(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 35, bottom: 0, right: 22), cursorColor: UIColor = CustomColor.red) {
        self.insets = insets
        super.init(frame: .zero)
        self.tintColor = cursorColor
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Customize
    // 텍스트필드 인셋
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    //  텍스트필드 인셋
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: insets)
    }
    // 클리어 버튼 인셋
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.clearButtonRect(forBounds: bounds)
        return rect.offsetBy(dx: -insets.right, dy: 0)
    }
    // 클리어버튼 커스텀 컬러 지정
    override func layoutSubviews() {
        super.layoutSubviews()

        for view in subviews {
            if let button = view as? UIButton {
                button.setImage(button.image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
                button.tintColor = CustomColor.gray60
            }
        }
    }
}
