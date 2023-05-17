//
//  InterestedGenreCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/06.
//

import UIKit

import Then
import SnapKit

final class InterestedGenreCVC: UICollectionViewCell {
    // MARK: Properties
    override var isSelected: Bool {
        willSet {
            isUserSelected(newValue)
        }
    }
    
    /// 회원 가입, 전체 장르 선택할 때 사용
    var allGenre: AllGenre?
    
    /// 글쓰기, 카테고리 선택할 때 사용
    var genreString: String?
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    let textLabel = UILabel().then {
        $0.textColor = CustomColor.label
        $0.font = .caption_B
    }
    let baseView = UIView().then {
        $0.layer.cornerRadius = 15
    }
    // MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        setConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 셀 선택여부에 따라 디자인 변경
    private func isUserSelected(_ bool: Bool = false) {
        switch bool {
        case true:
            textLabel.textColor = CustomColor.white
            baseView.backgroundColor = CustomColor.red
            imageView.image = UIImage(named: "checkmark-white")
        case false:
            textLabel.textColor = CustomColor.label
            baseView.backgroundColor = CustomColor.gray10
            imageView.image = UIImage(named: "checkmark-black")?.withTintColor(
                CustomColor.label ,
                renderingMode: .alwaysOriginal
            )
        }
    }
    
    func configureCell(with genre: AllGenre) {
        self.allGenre = genre
        self.textLabel.text = genre.text
    }
    
    func configurePostProductsCell(with genre: ProductsCategory) {
        self.textLabel.text = genre.text
        self.genreString = genre.rawValue
    }
    
    func configurePostWorksCell(with genre: WorksCategory) {
        self.textLabel.text = genre.text
        self.genreString = genre.rawValue
    }
    
    private func setupUI() {
        backgroundColor = .clear
        contentView.addSubviews(
            baseView, imageView, textLabel
        )
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalToSuperview().inset(8)
            make.centerY.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(8)
        }
        
        textLabel.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(2)
            make.centerY.equalTo(imageView)
            make.trailing.equalToSuperview().inset(15)
        }
        
        baseView.snp.makeConstraints { make in
            make.top.equalTo(imageView).offset(-8)
            make.bottom.equalTo(imageView).offset(8)
            make.leading.equalTo(imageView).offset(-8)
            make.trailing.equalTo(textLabel).offset(15)
        }
        
        isUserSelected()
    }
}
