//
//  UICollectionView+Extension.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/17.
//

import UIKit

extension UICollectionView {
    func getCell<T: UICollectionViewCell>(at indexPath: IndexPath) -> T {
        guard let cell = self.cellForItem(at: indexPath) as? T else { return T() }
        return cell
    }
}
