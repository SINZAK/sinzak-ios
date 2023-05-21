//
//  SuggestPriceCheckButton.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/21.
//

import UIKit

final class CircleCheckButton: UIButton {
    
    override var isSelected: Bool {
        willSet {
            switch newValue {
            case true:
                setImage(
                    SZImage.Icon.checkCirclePressed,
                    for: .normal
                )
                
            case false:
                setImage(
                    SZImage.Icon.checkCircleNotPressed,
                    for: .normal
                )
            }
        }
    }
}
