//
//  SZIcon.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/15.
//

import UIKit

struct SZImage {
    
    enum Icon {
        static let dismiss = UIImage(named: "dismiss")?
            .withTintColor(
                CustomColor.label,
                renderingMode: .alwaysOriginal
            )
        
        static let camera = UIImage(named: "camera")?
            .withTintColor(
                CustomColor.label,
                renderingMode: .alwaysOriginal
            )
        
        static let checkCircleNotPressed = UIImage(named: "check-circle-default")?
            .withTintColor(
                CustomColor.label,
                renderingMode: .alwaysOriginal
            )
        
        static let checkCirclePressed = UIImage(named: "check-circle-pressed")?
            .withTintColor(
                CustomColor.label,
                renderingMode: .alwaysOriginal
            )
    }
    
    enum Image {
        
        /// tint color: CustomColor.gray60
        static let nothing = UIImage(named: "nothing")?
            .withTintColor(
                CustomColor.gray60,
                renderingMode: .alwaysOriginal
            )
    }
}
