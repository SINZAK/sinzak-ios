//
//  SchoolAuthButton.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/15.
//

import UIKit

final class SchoolAuthButton: UIButton {
    override var isEnabled: Bool {
        willSet {
            if newValue {
                self.backgroundColor = CustomColor.red
                self.setTitleColor(CustomColor.white, for: .normal)
            } else {
                self.backgroundColor = CustomColor.red.withAlphaComponent(0.5)
                self.setTitleColor(CustomColor.white.withAlphaComponent(0.9), for: .disabled)
            }
        }
    }
}
