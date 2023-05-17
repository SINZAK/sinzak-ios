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
    }
    
    enum Image {
        
        /// tint color - CustomColor.gray60
        static let nothing = UIImage(named: "nothing")?
            .withTintColor(
                CustomColor.gray60,
                renderingMode: .alwaysOriginal
            )
    }
}
