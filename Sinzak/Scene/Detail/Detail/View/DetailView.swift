//
//  DetailView.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/26.
//

import UIKit
import SnapKit
import Then

final class DetailView: SZView {
    // MARK: - Properties
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
    // 상단 이미지 페이저 콜렉션 뷰
    let imagePagerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        $0.backgroundColor = CustomColor.gray10
    }
    let pagerControl = UIPageControl().then {
        $0.numberOfPages = 4
        $0.currentPage = 1
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
        $0.textColor = CustomColor.black
        $0.text = "홍대입구 3번 출구 앞 카포엠 로고 작업해주실 분 구합니다."
        $0.addInterlineSpacing()
        $0.numberOfLines = 0
    }
    let priceStackView = UIStackView().then {
        $0.spacing = 4
        $0.axis = .horizontal
    }
    let isDealing = UIImageView().then {
        $0.image = UIImage(named: "isDealing")
        $0.contentMode = .scaleAspectFit
    }
    let priceLabel = UILabel().then {
        $0.font = .subtitle_B
        $0.textColor = CustomColor.black
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
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 12
        $0.image = UIImage(named: "chat-thumbnail")
    }
    let authorNameLabel = UILabel().then {
        $0.font = .body_R
        $0.textColor = CustomColor.black
        $0.text = "김신작"
    }
    let badgeImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "verified-badge")
    }
    let schoolLabel = UILabel().then {
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
        $0.layer.borderColor = CustomColor.red?.cgColor
    }
    // 상세사이즈 뷰
    let detailSizeView = UIView().then {
        $0.backgroundColor = .clear
    }
    let detailTitle = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.black
        $0.text = I18NStrings.detailSize
    }
    let sizeTableView = UITableView().then {
        $0.backgroundColor = CustomColor.gray10
    }
    // 작품상세 또는 의뢰 상세
    let contentView = UIView().then {
        $0.backgroundColor = .clear
    }
    let contentLabel = UILabel().then {
        $0.font = .body_M
        $0.textColor = CustomColor.black
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
        $0.backgroundColor = CustomColor.white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowOpacity = 0.4
        $0.layer.shadowRadius = 5
    }
    let heartButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init("11") // 숫자
        titleAttr.font = .caption_B
        config.attributedTitle = titleAttr
        config.image = UIImage(named: "heart-blank")
        config.imagePadding = 6
        config.imagePlacement = .top
        config.baseForegroundColor = CustomColor.gray60
        $0.configuration = config
    }
    let verticalDivider = UIView().then {
        $0.backgroundColor = CustomColor.gray60
    }
    let scrapButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        var titleAttr = AttributedString.init(I18NStrings.scrap) // 숫자
        titleAttr.font = .caption_B
        config.attributedTitle = titleAttr
        config.image = UIImage(named: "scrap-blank")
        config.imagePadding = 6
        config.imagePlacement = .top
        config.baseForegroundColor = CustomColor.gray60
        $0.configuration = config
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
    // MARK: - Design Helpers
    override func setView() {
        addSubviews(
            scrollView,
            pagerControl,
            bottomActionView
        )
        bottomActionView.addSubviews(
            heartButton, verticalDivider, scrapButton,
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
            isDealing, priceLabel
        )
        authorView.addSubviews(
            authorImageView,
            authorNameLabel,
            badgeImageView,
            schoolLabel,
            followerLabel,
            followerCountLabel,
            followButton
        )
        detailSizeView.addSubviews(
            detailTitle,
            sizeTableView
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
        pagerControl.snp.makeConstraints { make in
            make.bottom.equalTo(imagePagerCollectionView).offset(-12)
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
        heartButton.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(56)
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(20)
        }
        verticalDivider.snp.makeConstraints { make in
            make.width.equalTo(0.5)
            make.height.centerY.equalTo(heartButton)
            make.leading.equalTo(heartButton.snp.trailing).offset(8)
        }
        scrapButton.snp.makeConstraints { make in
            make.width.height.top.equalTo(heartButton)
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
            make.top.equalTo(authorImageView).offset(2)
        }
        badgeImageView.snp.makeConstraints { make in
            make.width.height.equalTo(20)
            make.leading.equalTo(authorNameLabel.snp.trailing)
            make.centerY.equalTo(authorNameLabel)
        }
        schoolLabel.snp.makeConstraints { make in
            make.leading.equalTo(authorNameLabel)
            make.top.equalTo(authorNameLabel.snp.bottom).offset(4)
        }
        followerLabel.snp.makeConstraints { make in
            make.leading.equalTo(schoolLabel.snp.trailing)
            make.centerY.equalTo(schoolLabel)
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
        sizeTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(34)
            make.top.equalTo(detailTitle.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(16)
            make.height.equalTo(72)
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
    }
}
