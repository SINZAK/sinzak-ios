//
//  Int+Extension.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/01.
//

import Foundation

extension Int {
    
    /**
     100,000원 형식으로 변경
     */
    func toMoenyFormat() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return (numberFormatter.string(from: NSNumber(value: self)) ?? "-1") + "원"
    }
}
