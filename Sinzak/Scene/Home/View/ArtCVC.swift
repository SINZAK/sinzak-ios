//
//  ArtCVC.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/13.
//

import UIKit
import SnapKit
import Then
import Kingfisher
import SkeletonView
import RxSwift
import RxCocoa

final class ArtCVC: UICollectionViewCell {
    // MARK: - Properties
    
    var products: Products?
    var needLoginAlert: PublishRelay<Bool>?
    var disposeBag = DisposeBag()

    // MARK: - UI
    
    private let imageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "emptySquare")
        $0.isSkeletonable = true
    }
    
    private let likeView: LikeView = {
        let view = LikeView()
        view.layer.cornerRadius = 16.0
        
        return view
    }()
    
    private let titleLabel = UILabel().then {
        $0.textColor = CustomColor.label
        $0.font = .body_M
        $0.text = "Flower Garden"
        $0.isSkeletonable = true
    }
    private let labelStack = UIStackView().then {
        $0.spacing = 2
        $0.axis = .horizontal
        $0.isSkeletonable = true
    }
    private let isDealing = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
        $0.image = UIImage(named: "isDealing")
    }
    private let priceLabel = UILabel().then {
        $0.textColor = CustomColor.label
        $0.font = .body_B
        $0.text = "33,000원"
        $0.isSkeletonable = true

    }
    private let authorLabel = UILabel().then {
        $0.textColor = CustomColor.label
        $0.font = .caption_R
        $0.text = "신작 작가"
        $0.isSkeletonable = true
    }
    private let middlePointLabel = UILabel().then {
        $0.textColor = CustomColor.gray60
        $0.font = .caption_M
        $0.text = "· "
    }
    private let uploadTimeLabel = UILabel().then {
        $0.textColor = CustomColor.gray60
        $0.font = .caption_M
        $0.text = "10시간 전"
        $0.isSkeletonable = true
    }
    
    private let productForSkeleton = Products(
        id: 0, title: "      ",
        content: "", author: "             ",
        price: 30000, thumbnail: "skeleton",
        date: "       ", suggest: false,
        likesCnt: 100, complete: false,
        popularity: 100, like: false
    )
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setConstraints()
        isSkeletonable = true
        contentView.isSkeletonable = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setter
    func setData(_ data: Products, _ relay: PublishRelay<Bool>) {
        self.products = data
        self.needLoginAlert = relay
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if let thumbnail = data.thumbnail {
            let url = URL(string: thumbnail)
            imageView.kf.setImage(with: url)
        } else {
            imageView.image = UIImage(named: "emptySquare")
        }
        titleLabel.text = data.title
        authorLabel.text = data.author
        uploadTimeLabel.text = data.date.toDate().toRelativeString()
        priceLabel.text = (numberFormatter.string(from: NSNumber(value: Int(data.price))) ?? "0") + "원"
        likeView.likesCount = data.likesCnt
        likeView.isSelected = data.like
    }
    
    func setSkeleton() {
        likeView.isHidden = true
        middlePointLabel.isHidden = true
        uploadTimeLabel.isHidden = true
        imageView.image = nil
        [titleLabel, priceLabel, authorLabel].forEach { $0.textColor = .clear }
        titleLabel.text = "dfdfdfdfdfhdd"
        priceLabel.text = "fdffd"
        authorLabel.text = "fdfddddd"
    }
    
    // MARK: - Design Helpers
    private func setupUI() {
        contentView.isSkeletonable = true
        contentView.backgroundColor = .clear
        contentView.addSubviews(
            imageView, likeView,
            titleLabel, labelStack,
            authorLabel, middlePointLabel, uploadTimeLabel
        )
        
        labelStack.addArrangedSubviews(
            isDealing, priceLabel
        )
        
        let tapLikeView = UITapGestureRecognizer(
            target: self,
            action: #selector(tapLikeView)
        )
        likeView.addGestureRecognizer(tapLikeView)
    }
    
    private func setConstraints() {
        imageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(imageView.snp.width)
        }
        
        likeView.snp.makeConstraints {
            $0.trailing.bottom.equalTo(imageView).inset(10)
            $0.width.height.equalTo(32)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(7)
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(7)
        }
        labelStack.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.trailing.lessThanOrEqualToSuperview().inset(7)
        }
        isDealing.snp.makeConstraints { make in
            make.width.equalTo(35)
            make.height.equalTo(18)
            make.centerY.equalToSuperview()
        }
        authorLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.top.equalTo(labelStack.snp.bottom).offset(5)
        }
        middlePointLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authorLabel)
            make.leading.equalTo(authorLabel.snp.trailing)
        }
        uploadTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(middlePointLabel)
            make.leading.equalTo(middlePointLabel.snp.trailing)
            make.trailing.lessThanOrEqualToSuperview().inset(7)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
        titleLabel.text = nil
        authorLabel.text = nil
        uploadTimeLabel.text = nil
        priceLabel.text = nil
        likeView.likeImageView.image = nil
        likeView.likeCountLabel.text = nil
    }
}

private extension ArtCVC {
    
    @objc
    func tapLikeView() {
        if !likeView.isSelected {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        
        ProductsManager.shared.likeProducts(
            id: products?.id ?? 1,
            mode: !likeView.isSelected
        )
        .observe(on: MainScheduler.instance)
        .subscribe(
            with: self,
            onSuccess: { owner, _ in
                owner.likeView.isSelected.toggle()
                if owner.likeView.isSelected {
                    owner.likeView.likesCount += 1
                } else {
                    owner.likeView.likesCount -= 1
                }
            }, onFailure: { _, error  in
                Log.error(error)
            })
        .disposed(by: disposeBag)
        
    }
}
