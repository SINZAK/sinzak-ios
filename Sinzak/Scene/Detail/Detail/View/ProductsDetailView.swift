//
//  DetailView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/26.
//

import UIKit
import SnapKit
import Then

final class ProductsDetailView: SZView {
    // MARK: - Properties
    
    var products: ProductsDetail?
    
    var type: DetailType = .purchase {
        willSet {
            
        }
    }
    
    var owner: DetailOwner = .other {
        willSet {
            if newValue == .mine {
                followButton.isHidden = true
                priceOfferButton.isHidden = true
                askDealButtton.setTitle(
                    "문의 중인 채팅방 \(products?.chatCnt ?? 0)",
                    for: .normal
                )
                askDealButtton.setImage(nil, for: .normal)
            }
        }
    }
    
    var complete: Bool = false {
        willSet {
            switch (owner, type, newValue) {
            case (.mine, .purchase, false):
                isCompleteButton.setImage(UIImage(named: "mine-purchase-false"), for: .normal)
                
            case (.mine, .purchase, true):
                isCompleteButton.setImage(UIImage(named: "mine-purchase-true"), for: .normal)

            case (.mine, .request, false):
                isCompleteButton.setImage(UIImage(named: "mine-request-false"), for: .normal)
                
            case (.mine, .request, true):
                isCompleteButton.setImage(UIImage(named: "mine-request-true"), for: .normal)

            case (.other, .purchase, false):
                isCompleteButton.setImage(UIImage(named: "other-purchase-false"), for: .normal)
                isCompleteButton.isEnabled = false
                
            case (.other, .purchase, true):
                isCompleteButton.setImage(UIImage(named: "other-purchase-true"), for: .normal)
                isCompleteButton.isEnabled = false
                
                askDealButtton.isEnabled = false
                askDealButtton.setTitle("거래완료", for: .normal)
                askDealButtton.setImage(nil, for: .normal)
                askDealButtton.backgroundColor = CustomColor.gray40
                priceOfferButton.isHidden = true
                
            case (.other, .request, false):
                isCompleteButton.setImage(UIImage(named: "other-request-false"), for: .normal)
                isCompleteButton.isEnabled = false
                
            case (.other, .request, true):
                isCompleteButton.setImage(UIImage(named: "other-request-true"), for: .normal)
                isCompleteButton.isEnabled = false
                
                askDealButtton.isEnabled = false
                askDealButtton.setTitle("모집완료", for: .normal)
                askDealButtton.setImage(nil, for: .normal)
                askDealButtton.backgroundColor = CustomColor.gray40
                priceOfferButton.isHidden = true
            }
        }
    }
    
    var isFollowing: Bool = false {
        willSet {
            if newValue {
                followButton.setTitle("팔로잉", for: .normal)
                followButton.backgroundColor = CustomColor.red
                followButton.setTitleColor(CustomColor.white, for: .normal)
            } else {
                followButton.setTitle(I18NStrings.follow, for: .normal)
                followButton.backgroundColor = .clear
                followButton.setTitleColor(CustomColor.red, for: .normal)
            }
        }
    }
    
    var isLike: Bool = false {
        willSet {
            if newValue {
                likeButton.configuration?.image = UIImage(named: "favorite-fill")?
                    .withTintColor(CustomColor.red, renderingMode: .alwaysOriginal)
                likeButton.configuration?.baseForegroundColor = CustomColor.red
            } else {
                likeButton.configuration?.image = UIImage(named: "favorite")?
                    .withTintColor(CustomColor.gray60, renderingMode: .alwaysOriginal)
                likeButton.configuration?.baseForegroundColor = CustomColor.gray60
            }
        }
    }
    
    var isScrap: Bool = false {
        willSet {
            if newValue {
                scrapButton.configuration?.image = UIImage(named: "scrap2-fill")?
                    .withTintColor(CustomColor.red, renderingMode: .alwaysOriginal)
                scrapButton.configuration?.baseForegroundColor = CustomColor.red
            } else {
                scrapButton.configuration?.image = UIImage(named: "scrap2-blank")?
                    .withTintColor(CustomColor.gray60, renderingMode: .alwaysOriginal)
                scrapButton.configuration?.baseForegroundColor = CustomColor.gray60
            }
        }
    }
    
    var isSuggest: Bool = false {
        willSet {
            if newValue {
                priceOfferButton.setTitle("가격 제안하기", for: .normal)
                priceOfferButton.setTitleColor(CustomColor.purple, for: .normal)
            } else {
                priceOfferButton.setTitle("가격 제안 불가", for: .normal)
                priceOfferButton.setTitleColor(CustomColor.gray60, for: .normal)
                priceOfferButton.isEnabled = false
            }
        }
    }
    
    // MARK: - UI
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .clear
        $0.isScrollEnabled = true
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    let stackView = UIStackView().then {
        $0.spacing = 0
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width, height: width)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        
        return layout
    }()
    
    // 상단 이미지 페이저 콜렉션 뷰
    lazy var imagePagerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).then {
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.register(
            PhotoCVC.self,
            forCellWithReuseIdentifier: PhotoCVC.identifier
        )
        $0.backgroundColor = CustomColor.gray10
    }
    let pageControl = UIPageControl().then {
        $0.isUserInteractionEnabled = false
        $0.currentPageIndicatorTintColor = CustomColor.red
        $0.pageIndicatorTintColor = CustomColor.gray60
    }
    // 작품 이름, 소개 뷰
    let titleView = UIView().then {
        $0.backgroundColor = .clear
    }
    let titleStackView = UIStackView().then {
        $0.spacing = 10
        $0.axis = .vertical
    }
    let titleNameLabel = UILabel().then {
        $0.font = .subtitle_B
        $0.textColor = CustomColor.label
        $0.text = "홍대입구 3번 출구 앞 카포엠 로고 작업해주실 분 구합니다."
        $0.addInterlineSpacing()
        $0.numberOfLines = 0
    }
    let priceStackView = UIStackView().then {
        $0.spacing = 10.0
        $0.axis = .horizontal
    }
//    let isCompleteImageView = UIImageView().then {
//        $0.image = UIImage(named: "isDealing")
//        $0.contentMode = .scaleAspectFit
//    }
    
    let isCompleteButton: UIButton = {
        let button = UIButton()
        button.setImage(
            UIImage(named: "products-complete"),
            for: .normal
        )
        
        return button
    }()
    
    let priceLabel = UILabel().then {
        $0.font = .subtitle_B
        $0.textColor = CustomColor.label
        $0.text = "43,000원"
        $0.numberOfLines = 0
    }
    let categoryLabel = UILabel().then {
        $0.font = .caption_R
        $0.textColor = CustomColor.gray60
        $0.text = "회화 일반"
        $0.setContentCompressionResistancePriority(.init(rawValue: 999), for: .horizontal)
    }
    let timeLabel = UILabel().then {
        $0.font = .caption_B
        $0.textColor = CustomColor.gray60
        $0.text = "방금 전"
    }
    // 디바이더
    let divider01 = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    let divider02 = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    let divider03 = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    // 작가 뷰
    let authorView = UIView().then {
        $0.backgroundColor = .clear
    }
    let authorImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.image = UIImage(named: "chat-thumbnail")
        $0.backgroundColor = .lightGray
    }
    let authorNameLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.label
        $0.text = "김신작"
    }
    let certBadgeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "verified-badge")
    }
    let uniLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.red50
        $0.text = "홍익대verified"
    }
    private let followerLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.gray60
        $0.text = "·" + I18NStrings.follower + " "
    }
    let followerCountLabel = UILabel().then {
        $0.font = .caption_M
        $0.textColor = CustomColor.gray60
        $0.text = "35"
    }
    let followButton = UIButton().then {
        $0.titleLabel?.font = .caption_M
        $0.setTitle(I18NStrings.follow, for: .normal)
        $0.setTitleColor(CustomColor.red, for: .normal)
        $0.layer.cornerRadius = 16
        $0.layer.borderWidth = 1.5
        $0.layer.borderColor = CustomColor.red.cgColor
    }
    // 상세사이즈 뷰
    let detailSizeView = UIView().then {
        $0.backgroundColor = .clear
    }
    let detailTitle = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.label
        $0.text = I18NStrings.detailSize
    }
    
    let widthLabel: UILabel = {
        let label = UILabel()
        label.text = "가로"
        label.font = .body_R
        label.textColor = CustomColor.label
        
        return label
    }()
    
    let verticalLabel: UILabel = {
        let label = UILabel()
        label.text = "세로"
        label.font = .body_R
        label.textColor = CustomColor.label
        
        return label
    }()
    
    let heightLabel: UILabel = {
        let label = UILabel()
        label.text = "높이"
        label.font = .body_R
        label.textColor = CustomColor.label
        
        return label
    }()
    
    let widthValueLabel: UILabel = {
        let label = UILabel()
        label.text = "45.5"
        label.font = .body_M
        label.textColor = CustomColor.label
        
        return label
    }()
    
    let verticalValueLabel: UILabel = {
        let label = UILabel()
        label.text = "45.5"
        label.font = .body_M
        label.textColor = CustomColor.label
        
        return label
    }()

    let heightValueLabel: UILabel = {
        let label = UILabel()
        label.text = "53"
        label.font = .body_M
        label.textColor = CustomColor.label
        
        return label
    }()
    
    let widthUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "cm"
        label.font = .body_R
        label.textColor = CustomColor.label
        
        return label
    }()
    
    let vertiaclUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "cm"
        label.font = .body_R
        label.textColor = CustomColor.label
        
        return label
    }()

    let heightUnitLabel: UILabel = {
        let label = UILabel()
        label.text = "cm"
        label.font = .body_R
        label.textColor = CustomColor.label
        
        return label
    }()
    
    let sizeTypeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.alignment = .center
        
        return stackView
    }()
    
    let sizeValueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.alignment = .center
        
        return stackView
    }()
    
    let sizeUnitStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16.0
        stackView.alignment = .center
        
        return stackView
    }()
    
    let sizeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    let sizeTableView = UITableView().then {
        $0.backgroundColor = CustomColor.gray10
    }
    // 작품상세 또는 의뢰 상세
    let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    let contentLabel = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.label
        $0.numberOfLines = 0
        $0.text = "나의 에고를 표현한 작품. 캔버스 10호. 아크릴.택배 거래 안돼요, 어쩌구 저쩌구. 홍대입구에서 직거래 선호합니다. 나의 에고를 표현한 작품. 캔버스 10호. 아크릴.택배 거래 안돼요, 어쩌구 저쩌구."
        $0.addInterlineSpacing(spacing: 4)
    }
    // 조회,북마크,문의수
    let postStatusView = UIView().then {
        $0.backgroundColor = .clear
    }
    private let scrapIcon = UIImageView().then {
        $0.image = UIImage(named: "scrap-mini")
        $0.contentMode = .scaleAspectFit
    }
    private let viewIcon = UIImageView().then {
        $0.image = UIImage(named: "view-mini")
        $0.contentMode = .scaleAspectFit
    }
    private let chatIcon = UIImageView().then {
        $0.image = UIImage(named: "chatbubble-mini")
        $0.contentMode = .scaleAspectFit
    }
    let scrapCountLabel = UILabel().then {
        $0.textColor = CustomColor.gray60
        $0.font = .caption_R
        $0.text = "0"
    }
    let viewCountLabel = UILabel().then {
        $0.textColor = CustomColor.gray60
        $0.font = .caption_R
        $0.text = "0"
    }
    let chatCountLabel = UILabel().then {
        $0.textColor = CustomColor.gray60
        $0.font = .caption_R
        $0.text = "0"
    }
    // 아래쪽 뷰 - 하트, 찜, 거래문의 등
    let bottomActionView = UIView().then {
        $0.backgroundColor = CustomColor.background
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowOpacity = 0.4
        $0.layer.shadowRadius = 5
    }
    let likeButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("11") // 숫자
        titleAttr.font = .caption_B
        config.attributedTitle = titleAttr
        config.image = UIImage(named: "favorite")?.withTintColor(CustomColor.gray60, renderingMode: .alwaysOriginal)
        config.imagePadding = 6
        config.imagePlacement = .top
        config.baseForegroundColor = CustomColor.gray60
        $0.configuration = config
        $0.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(30.0)
            $0.centerX.equalToSuperview()
        }
    }
    let verticalDivider = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    let scrapButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init(I18NStrings.scrap) // 숫자
        titleAttr.font = .caption_B
        config.attributedTitle = titleAttr
        config.image = UIImage(named: "scrap2-blank")?.withTintColor(CustomColor.gray60, renderingMode: .alwaysOriginal)
        config.imagePadding = 6
        config.imagePlacement = .top
        config.baseForegroundColor = CustomColor.gray60
        $0.configuration = config
        $0.imageView?.snp.makeConstraints {
            $0.width.height.equalTo(30.0)
            $0.centerX.equalToSuperview()
        }
    }
    let askDealButtton = UIButton().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 24
        $0.setImage(UIImage(named: "chatbubble-blank"), for: .normal)
        $0.setTitle(" " + I18NStrings.askDeal, for: .normal)
        $0.titleLabel?.font = .body_B
        $0.setTitleColor(CustomColor.white, for: .normal)
        $0.tintColor = CustomColor.white
        $0.backgroundColor = CustomColor.red
    }
    let priceOfferButton = UIButton().then {
        $0.setTitle(I18NStrings.sendPriceOffer, for: .normal)
        $0.setTitleColor(CustomColor.purple, for: .normal)
        $0.titleLabel?.font = .caption_B
    }
    
    let skeletonView = ProductsDetailSkeletonView()
    
    // MARK: - Setter
    func setData(_ data: ProductsDetail, _ type: DetailType?) {
        
        self.products = data
        self.type = type ?? .purchase
        self.owner = data.myPost ? .mine : .other
        
        pageControl.numberOfPages = (data.images ?? []).count
        pageControl.currentPage = 0
        
        titleNameLabel.text = data.title
        categoryLabel.text = CategoryType(rawValue: data.category)?.text

        self.complete = data.complete
        priceLabel.text = data.price.toMoenyFormat()
        timeLabel.text = data.date.toDate().toRelativeString()
        
        authorImageView.kf.setImage(with: URL(string: data.authorPicture))
        authorNameLabel.text = data.author
        certBadgeImageView.isHidden = !data.certAuthor
        var uniText: String = ""
        var followerText: String = "팔로워 "
        self.isFollowing = data.following
        
        if let univ = data.univ, !univ.isEmpty, data.certUni {
            let univ = univ.replacingOccurrences(of: "학교", with: "")
            uniText += univ + "verified"
            followerText = "·팔로워 "
        } else if let univ = data.univ, !univ.isEmpty, !data.certUni {
            let univ = univ.replacingOccurrences(of: "학교", with: "")
            uniText += univ
            followerText = "unverified·팔로워 "
        }
        uniLabel.text = uniText
        followerLabel.text = followerText
        followerCountLabel.text = data.followerNum
        
        widthValueLabel.text = "\(Int(data.width))"
        verticalValueLabel.text = "\(Int(data.vertical))"
        heightValueLabel.text = "\(Int(data.height))"
        
        contentLabel.text = data.content
        
        scrapCountLabel.text = "\(data.wishCnt)"
        viewCountLabel.text = "\(data.views)"
        chatCountLabel.text = "\(data.chatCnt)"
        
        self.isLike = data.like
        self.isScrap = data.wish
        likeButton.setTitle("\(data.likesCnt)", for: .normal)
        
        self.isSuggest = data.suggest
    }
    // MARK: - Design Helpers
    override func setView() {
        isSkeletonable = true
        addSubviews(
            scrollView,
            pageControl,
            bottomActionView,
            skeletonView
        )
        bottomActionView.addSubviews(
            likeButton, verticalDivider, scrapButton,
            askDealButtton, priceOfferButton
        )
        scrollView.addSubview(stackView)
        // 스택에 뷰 추가하기
        stackView.addArrangedSubviews(
            imagePagerCollectionView,
            titleView,
            divider01,
            authorView,
            divider02,
            detailSizeView,
            divider03,
            contentView,
            postStatusView
        )
        titleView.addSubviews(
            titleStackView,
            categoryLabel,
            timeLabel
        )
        titleStackView.addArrangedSubviews(
            titleNameLabel,
            priceStackView
        )
        priceStackView.addArrangedSubviews(
            isCompleteButton, priceLabel
        )
        authorView.addSubviews(
            authorImageView,
            authorNameLabel,
            certBadgeImageView,
            uniLabel,
            followerLabel,
            followerCountLabel,
            followButton
        )
        
        sizeTypeStackView.addArrangedSubviews(
            widthLabel,
            verticalLabel,
            heightLabel
        )
        
        sizeValueStackView.addArrangedSubviews(
            widthValueLabel,
            verticalValueLabel,
            heightValueLabel
        )
        
        sizeUnitStackView.addArrangedSubviews(
            widthUnitLabel,
            vertiaclUnitLabel,
            heightUnitLabel
        )
        
        sizeStackView.addArrangedSubviews(
            sizeTypeStackView,
            sizeValueStackView,
            sizeUnitStackView
        )
        
        detailSizeView.addSubviews(
            detailTitle,
            sizeStackView
        )
        contentView.addSubview(
            contentLabel
        )
        postStatusView.addSubviews(
            scrapIcon, scrapCountLabel,
            viewIcon, viewCountLabel,
            chatIcon, chatCountLabel
        )
    }
    override func setLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(bottomActionView.snp.top)
        }
        stackView.snp.makeConstraints { make in
            make.top.bottom.width.equalToSuperview()
        }
        imagePagerCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(imagePagerCollectionView.snp.width)
        }
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(imagePagerCollectionView).offset(-4.0)
            make.centerX.equalToSuperview()
        }
        titleView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imagePagerCollectionView.snp.bottom)
        }
        categoryLabel.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
        }
        timeLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(categoryLabel.snp.bottom).offset(16)
            make.trailing.bottom.equalToSuperview().inset(20)
        }
        titleStackView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(categoryLabel.snp.leading).offset(-16)
        }
        priceStackView.snp.makeConstraints { make in
            make.leading.equalTo(titleNameLabel)
            make.bottom.equalToSuperview().inset(16)
            make.top.greaterThanOrEqualTo(titleNameLabel.snp.bottom).offset(10)
        }
        bottomActionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(123)
        }
        likeButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(56)
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(20)
        }
        verticalDivider.snp.makeConstraints { make in
            make.width.equalTo(0.5)
            make.height.centerY.equalTo(likeButton)
            make.leading.equalTo(likeButton.snp.trailing).offset(8)
        }
        scrapButton.snp.makeConstraints { make in
            make.width.height.top.equalTo(likeButton)
            make.leading.equalTo(verticalDivider.snp.trailing).offset(8)
        }
        askDealButtton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.leading.equalTo(scrapButton.snp.trailing).offset(20)
            make.height.equalTo(48)
            make.top.equalToSuperview().inset(11)
        }
        priceOfferButton.snp.makeConstraints { make in
            make.leading.trailing.equalTo(askDealButtton)
            make.top.equalTo(askDealButtton.snp.bottom).offset(4)
            make.height.equalTo(24)
        }
        divider01.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(0.5)
        }
        authorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        authorImageView.snp.makeConstraints { make in
            make.width.height.equalTo(42)
            make.centerY.equalToSuperview()
            make.leading.top.bottom.equalToSuperview().inset(20)
        }
        authorNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorImageView.snp.trailing).offset(9)
            make.top.equalTo(authorImageView)
        }
        certBadgeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalTo(authorNameLabel.snp.trailing)
            make.centerY.equalTo(authorNameLabel).offset(-1.0)
        }
        uniLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorNameLabel)
            make.bottom.equalTo(authorImageView)
        }
        followerLabel.snp.makeConstraints { make in
            make.leading.equalTo(uniLabel.snp.trailing)
            make.bottom.equalTo(authorImageView)
        }
        followerCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(followerLabel.snp.trailing)
            make.centerY.equalTo(followerLabel)
        }
        followButton.snp.makeConstraints { make in
            make.width.equalTo(64)
            make.height.equalTo(32)
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        divider02.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(0.5)
        }
        detailSizeView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        detailTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(16)
        }
        
        sizeStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(48.0)
            $0.trailing.equalToSuperview().inset(44.0)
            $0.top.equalTo(detailTitle.snp.bottom).offset(8.0)
            $0.bottom.equalToSuperview().inset(16.0)
        }
        
        divider03.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(0.5)
        }
        contentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(30)
        }
        postStatusView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
        }
        scrapIcon.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.top.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(30)
        }
        scrapCountLabel.snp.makeConstraints { make in
            make.leading.equalTo(scrapIcon.snp.trailing)
            make.centerY.equalTo(scrapIcon)
        }
        viewIcon.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(scrapIcon)
            make.leading.equalTo(scrapCountLabel.snp.trailing).offset(8)
        }
        viewCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(viewIcon)
            make.leading.equalTo(viewIcon.snp.trailing)
        }
        chatIcon.snp.makeConstraints { make in
            make.centerY.width.height.equalTo(scrapIcon)
            make.leading.equalTo(viewCountLabel.snp.trailing).offset(8)
        }
        chatCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(chatIcon)
            make.leading.equalTo(chatIcon.snp.trailing)
        }
        
        skeletonView.snp.makeConstraints {
            $0.top.bottom.equalTo(safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
