//
//  UIView+Extension.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/02.
//

import UIKit

extension UIView {
    func roundCorners(
        _ corners: UIRectCorner,
        radius: CGFloat
    ) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
