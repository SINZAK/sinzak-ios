//
//  SZButton.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/07.
//

import UIKit

final class SZButton: UIButton {
    override var isEnabled: Bool {
        willSet {
            if newValue {
                self.backgroundColor = CustomColor.red
                self.setTitleColor(CustomColor.white, for: .normal)
            } else {
                self.backgroundColor = CustomColor.gray20
                self.setTitleColor(CustomColor.gray10, for: .disabled)
            }
        }
    }
}
