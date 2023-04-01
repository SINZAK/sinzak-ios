//
//  UICollectionReusableView+Extentsion.swift
//  Sinzak
//
//  Created by JongHoon on 2023/03/31.
//

import UIKit

extension UICollectionReusableView {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
