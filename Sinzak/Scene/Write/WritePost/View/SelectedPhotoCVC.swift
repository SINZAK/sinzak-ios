//
//  SelectedPhotoCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/24.
//

import UIKit
import SnapKit
import Then

final class SelectedPhotoCVC: UICollectionViewCell {
    // MARK: - Properties
    
    var deleteImage: ((UIImage) -> Void)?
    
    // MARK: - UI
    
    private lazy var removePhotoButton = UIButton().then {
        $0.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        $0.setImage(UIImage(named: "exclude"), for: .normal)
        $0.imageView?.contentMode = .center
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "emptySquare")
        $0.layer.borderColor = CustomColor.gray60.cgColor
        $0.layer.borderWidth = 1.0
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private let thumbnailLabel = UILabel().then {
        $0.font = .caption_B
        $0.textColor = CustomColor.red50
        $0.text = "썸네일"
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
    
    func configCellImage(with image: UIImage) {
        imageView.image = image
    }
    
    func configThumbnailCell() {
        thumbnailLabel.isHidden = false
        imageView.layer.borderColor = CustomColor.red50.cgColor
    }
    
    func configNotThumbnailCell() {
        thumbnailLabel.isHidden = true
        imageView.layer.borderColor = CustomColor.gray60.cgColor
    }

    override func prepareForReuse() {
        imageView.image = nil
        thumbnailLabel.isHidden = true
        imageView.layer.borderColor = CustomColor.gray60.cgColor
    }
    
    // MARK: - Helpers
    private func updateImage(_ image: UIImage) {
        imageView.image = image
        thumbnailLabel.isHidden = true
        imageView.layer.borderColor = CustomColor.gray60.cgColor
    }
    // MARK: - Design Helpers
    private func setupUI() {
        contentView.addSubviews(
            imageView,
            thumbnailLabel,
            removePhotoButton
        )
    }
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(72.0)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        removePhotoButton.snp.makeConstraints { make in
            make.width.height.equalTo(20.0)
            make.trailing.equalTo(imageView).offset(5)
            make.top.equalTo(imageView).offset(-5)
        }
        
        thumbnailLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(8.0)
            make.bottom.equalTo(imageView.snp.top).offset(-2.0)
        }
    }
    
    @objc
    func deleteTapped() {
        deleteImage?(imageView.image ?? UIImage())
    }
}
