//
//  VerifyButton.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/15.
//

import UIKit

final class VerifyButton: UIButton {
    override var isEnabled: Bool {
        willSet {
            switch newValue {
            case true:
                setTitle("인증하기", for: .normal)
                setTitleColor(CustomColor.purple, for: .application)
                
            case false:
                setTitle("인증완료", for: .disabled)
                setTitleColor(CustomColor.gray60, for: .disabled)
            }
        }
    }
}
