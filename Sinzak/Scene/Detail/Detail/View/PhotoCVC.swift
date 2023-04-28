//
//  PhotoCVC.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/28.
//

import UIKit
import Kingfisher

final class PhotoCVC: UICollectionViewCell {
    
    var imageURL: String?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(_ url: String) {
        imageURL = url
        imageView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "emptySquare"))
    }
    
    private func configureLayout() {
        addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
