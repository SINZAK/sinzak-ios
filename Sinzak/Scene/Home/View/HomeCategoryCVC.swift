//
//  HomeCategoryCell.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/24.
//

import UIKit
import SnapKit

final class HomeCategoryCVC: UICollectionViewCell {

    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with image: UIImage?) {
        self.imageView.image = image
    }
    
    private func configureLayout() {
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
