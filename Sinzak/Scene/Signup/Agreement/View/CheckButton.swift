//
//  CheckButton.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/07.
//

import UIKit

final class CheckButton: UIButton {
    
    override var isSelected: Bool {
        willSet {
            if newValue {
                self.setImage(UIImage(named: "checked"), for: .selected)
            } else {
                self.setImage(UIImage(named: "check"), for: .normal)
            }
        }
    }
}
