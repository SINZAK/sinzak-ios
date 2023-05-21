//
//  SZNumberTextField.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/21.
//

import UIKit

final class SZNumberTextField: SZTextField {
    
    /// 붙여넣기   비활성화
    override func canPerformAction(
        _ action: Selector,
        withSender sender: Any?
    ) -> Bool {
        if action == #selector(paste(_:)) {
            return false
        }
        
        return super.canPerformAction(action, withSender: sender)
    }
}
