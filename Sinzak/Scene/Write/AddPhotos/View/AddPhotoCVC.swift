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
    let removePhotoButton = UIButton().then {
        $0.setImage(UIImage(named: "exclude"), for: .normal)
    }
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "emptySquare")
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
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
    // MARK: - Helpers
    func updateImage(_ image: UIImage) {
        imageView.image = image
    }
    // MARK: - Design Helpers
    func setupUI() {
        contentView.addSubviews(
            imageView, removePhotoButton
        )
    }
    func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(100)
            make.bottom.leading.equalToSuperview()
        }
        removePhotoButton.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.trailing.equalTo(imageView).offset(5)
            make.top.equalTo(imageView).offset(-5)
        }
    }
}
