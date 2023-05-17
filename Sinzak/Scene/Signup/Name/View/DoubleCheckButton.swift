//
//  DoubleCheckButton.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/11.
//

import UIKit

final class DoubleCheckButton: UIButton {
    
    override var isEnabled: Bool {
        willSet {
            if newValue {
                self.layer.borderColor = CustomColor.red.cgColor
                self.setTitleColor(CustomColor.red, for: .normal)
            } else {
                self.layer.borderColor = CustomColor.gray60.cgColor
                self.setTitleColor(CustomColor.gray60, for: .disabled)
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        
        layer.borderWidth = 1.0
        titleLabel?.font = .caption_B
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
