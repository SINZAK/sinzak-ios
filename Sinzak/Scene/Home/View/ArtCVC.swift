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

enum ArtCellKind {
    case products
    case work
}

final class ArtCVC: UICollectionViewCell {
    // MARK: - Properties
    
    var products: Products?
    var kind: ArtCellKind?
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
    
    private let soldOutView: SoldOutView = {
        let view = SoldOutView()
        view.layer.cornerRadius = 12
        
        return view
    }()
    
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
        bind()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setter
    func setData(_ data: Products, _ kind: ArtCellKind, _ relay: PublishRelay<Bool>) {
        self.products = data
        self.kind = kind
        self.needLoginAlert = relay
        
        let nothingImage = UIImage(named: "nothing")?.withTintColor(CustomColor.gray60, renderingMode: .alwaysOriginal)
        
        if let thumbnail = data.thumbnail {
            let url = URL(string: thumbnail)
            imageView.kf.setImage(with: url, placeholder: nothingImage)
        } else {
            imageView.image = nothingImage
            imageView.backgroundColor = CustomColor.gray10
            imageView.contentMode = .center
        }
        titleLabel.text = data.title
        authorLabel.text = data.author
        uploadTimeLabel.text = data.date.toDate().toRelativeString()
        priceLabel.text = data.price.toMoenyFormat()
        likeView.likesCount = data.likesCnt
        likeView.isSelected = data.like
        likeView.isHidden = data.complete
        soldOutView.kind = kind
        soldOutView.isHidden = !data.complete
    }
    
    func setSkeleton() {
        likeView.isHidden = true
        middlePointLabel.isHidden = true
        uploadTimeLabel.isHidden = true
        imageView.image = nil
        soldOutView.isHidden = true
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
            imageView,
            titleLabel, labelStack,
            authorLabel, middlePointLabel, uploadTimeLabel,
            soldOutView,
            likeView
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
            make.width.height.equalTo(164.0)
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
        authorLabel.setContentCompressionResistancePriority(.init(250), for: .horizontal)
        
        middlePointLabel.snp.makeConstraints { make in
            make.centerY.equalTo(authorLabel)
            make.leading.equalTo(authorLabel.snp.trailing)
        }
        uploadTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(middlePointLabel)
            make.leading.equalTo(middlePointLabel.snp.trailing)
            make.trailing.lessThanOrEqualToSuperview().inset(7)
        }
        uploadTimeLabel.setContentCompressionResistancePriority(.init(750), for: .horizontal)
        
        soldOutView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.height.equalTo(imageView)
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
        imageView.contentMode = .scaleAspectFill
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
                    UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
                        owner.likeView.likeImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                    }, completion: { _ in
                        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
                            owner.likeView.likeImageView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        })
                    })
                    owner.likeView.likesCount += 1
                } else {
                    owner.likeView.likesCount -= 1
                }
                
                // 홈, 마켓 화면에서 같은 셀 좋아요 상태 업데이트
                if owner.kind == .products {
                    NotificationCenter.default.post(
                        name: .cellLikeUpdate,
                        object: nil,
                        userInfo: [
                            "id": owner.products?.id ?? 1,
                            "kind": ArtCellKind.products,
                            "isSelected": owner.likeView.isSelected,
                            "likeCount": owner.likeView.likesCount
                        ]
                    )
                }
            }, onFailure: { _, error  in
                Log.error(error)
            })
        .disposed(by: disposeBag)
    }
    
    func bind() {
        NotificationCenter.default.rx.notification(.cellLikeUpdate)
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(with: self, onNext: { owner, notification in
                guard let info = notification.userInfo else { return }
                let id = info["id"] as? Int ?? 0
                let kind = info["kind"] as? ArtCellKind ?? .products
                let isSelected = info["isSelected"] as? Bool ?? false
                let likeCount = info["likeCount"] as? Int ?? 0
                
                if owner.products?.id == id && owner.kind == kind {
                    owner.likeView.isSelected = isSelected
                    owner.likeView.likesCount = likeCount
                }
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(.cellIsCompleteUpdate)
            .distinctUntilChanged()
            .asDriver(onErrorRecover: { _ in .never() })
            .drive(with: self, onNext: { owner, notification in
                guard let info = notification.userInfo else { return }
                
                let id = info["id"] as? Int ?? 0
                let kind = info["kind"] as? ArtCellKind ?? .work
                let isComplete = info["isComplete"] as? Bool ?? false
                
                if owner.products?.id == id, owner.kind == kind {
                    owner.soldOutView.isHidden = !isComplete
                }
            })
            .disposed(by: disposeBag)
    }
}
