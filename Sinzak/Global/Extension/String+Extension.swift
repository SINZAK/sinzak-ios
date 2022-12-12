//
//  String+Extension.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import UIKit

// 다국어 설정
extension String {
    var localized: String {
        Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
    
    func localized(arguments: CVarArg...) -> String{
        String(format: self.localized, arguments: arguments)
    }
}
