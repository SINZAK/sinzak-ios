//
//  AddPhotoCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/24.
//

import UIKit
import SnapKit
import Then

final class AddPhotoCVC: UICollectionViewCell {
    // MARK: - Properties
    private let removePhotoButton = UIButton().then {
        $0.addTarget(self, action: #selector(tap), for: .touchUpInside)
        $0.setImage(UIImage(named: "exclude"), for: .normal)
        $0.imageView?.contentMode = .center
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "emptySquare")
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private let thumbnailMarkSquare = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = 12
        $0.layer.borderColor = CustomColor.red50.cgColor
        $0.layer.borderWidth = 2.0
        $0.isHidden = true
    }
    let thumbnailLabel = UILabel().then {
        $0.font = .caption_B
        $0.textColor = CustomColor.red50
        $0.text = I18NStrings.thumbnail
        $0.isHidden = true
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(with photo: Photo) {
        imageView.image = photo.image
    }
    
    func showThumbnailMask() {
        thumbnailLabel.isHidden = false
        thumbnailMarkSquare.isHidden = false
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        thumbnailLabel.isHidden = true
        thumbnailMarkSquare.isHidden = true
    }
    
    // MARK: - Helpers
    private func updateImage(_ image: UIImage) {
        imageView.image = image
    }
    // MARK: - Design Helpers
    private func setupUI() {
        contentView.addSubviews(
            imageView,
            thumbnailMarkSquare,
            thumbnailLabel,
            removePhotoButton
        )
    }
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.centerX.centerY.equalTo(thumbnailMarkSquare)
//            make.leading.equalToSuperview()
//            make.centerY.equalToSuperview()
        }
        removePhotoButton.snp.makeConstraints { make in
            make.width.height.equalTo(20.0)
            make.trailing.equalTo(imageView).offset(5)
            make.top.equalTo(imageView).offset(-5)
        }
        thumbnailMarkSquare.snp.makeConstraints { make in
            make.width.height.equalTo(109)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
//            make.centerX.centerY.equalTo(imageView)
//            make.leading.equalToSuperview().inset(11.5)
//            make.bottom.equalTo(collectionView).offset(4.5)
        }
        
        thumbnailLabel.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailMarkSquare).offset(3)
            make.bottom.equalTo(thumbnailMarkSquare.snp.top).offset(-3)
        }
    }
    
    @objc
    func tap() {
        Log.debug("tap!!!!!")
    }
}
