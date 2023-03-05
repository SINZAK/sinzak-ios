//
//  I18NStrings.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import Foundation

struct I18NStrings {
    // - 공통
    static let confirm = "confirm".localized
    static let next = "next".localized
    static let cancel = "cancel".localized
    static let finish = "finish".localized
    static let edit = "edit".localized
    static let remove = "remove".localized
    static let report = "report".localized
    static let blockUser = "blockUser".localized
    
    // - 로그인 화면
    static let logoText = "logoText".localized
    static let startWithSnsLogin = "startWithSnsLogin".localized
    
    // - 회원가입 화면
    // 서비스 이용동의
    static let consentToUseOfService = "consentToUseOfService".localized
    static let fullAgree = "fullAgree".localized
    static let olderThanfourteenYears = "olderThanfourteenYears".localized
    static let requiredTermsOfService = "requiredTermsOfService".localized
    static let requiredPrivacyPolicy = "requiredPrivacyPolicy".localized
    static let optionalMarketingInformation = "optionalMarketingInformation".localized
    
    // 이름 입력
    static let pleaseEnterName = "pleaseEnterName".localized
    static let nameValidationDescription = "nameValidationDescription".localized
    
    // 관심장르 선택
    static let pleaseSelectGenreOfInterest = "pleaseSelectGenreOfInterest".localized
    static let upToThreeCanBeSelected = "upToThreeCanBeSelected".localized
    // 관심장르 종류
    // > 순수 예술
    static let fineart = "fineart".localized
    static let painting = "painting".localized // 회화일반
    static let orientalPainting = "orientalPainting".localized // 동양화
    static let sculpture = "sculpture".localized // 조소
    static let print = "print".localized // 판화
    static let craft = "craft".localized // 공예
    static let portrait = "portrait".localized // 초상화
    static let etc = "etc".localized // 기타
    // > 디자인
    static let design = "design".localized
    static let illust = "illust".localized // 일러스트
    static let packageLabel = "packageLabel".localized // 패키지/라벨
    static let printDesign = "printDesign".localized // 인쇄물
    static let posterBannerSign = "posterBannerSign".localized // 포스터/배너/간판
    static let logoBranding = "logoBranding".localized // 로고/브랜딩
    static let appWebDesign = "appWebDesign".localized// 앱/웹 디자인
    
    // 대학교 선택
    static let pleaseSelectUniversity = "pleaseSelectUniversity".localized
    static let searchBySchoolName = "searchBySchoolName".localized
    static let notStudent = "notStudent".localized
    static let verifyTypeSelect = "authTypeSelect".localized
    static let schoolWebmailAuth = "schoolWebmailAuth".localized
    static let schoolCardAuth = "schoolIdCardAuth".localized
    static let pleaseTypeSchoolEmail = "pleaseTypeSchoolEmail".localized
    static let uploadSchoolCardImage = "uploadSchoolCardImage".localized
    static let schoolEmailAuthDescription = "schoolEmailAuthDescription".localized
    static let schoolCardAuthDescription = "schoolCardAuthDescription".localized
    static let enterYourEmailInCorrectFormat = "enterYourEmailInCorrectFormat".localized
    static let authCode = "authCode".localized
    static let fourDigitPlease = "fourDigitPlease".localized
    static let verificationEmailHasBeenSent = "verificationEmailHasBeenSent".localized
    static let authenticated = "authenticated".localized
    // 대학교 인증
    static let enrolledStudentAuth = "enrolledStudentAuth".localized
    static let graduatedStudentAuth = "graduatedStudentAuth".localized
    static let schoolWebMailAuth = "schoolWebMailAuth".localized
    static let emailAuthDescription = "emailAuthDescription".localized
    static let pleaseEnterSchoolEmail = "pleaseEnterSchoolEmail".localized
    static let doNextTime = "doNextTime".localized
    static let sendMail = "sendMail".localized
    
    // 탭바 메뉴
    static let Home = "Home".localized
    static let Market = "Market".localized
    static let Outsourcing = "Outsourcing".localized
    static let Chat = "Chat".localized
    static let Profile = "Profile".localized
    // 비로그인 사용자용 화면
    static let youCanUseAfterLogin = "youCanUseAfterLogin".localized
    // 팔로워, 팔로잉
    static let follower = "follower".localized
    static let following = "following".localized
    static let follow = "follow".localized
    // 프로필편집
    static let editProfile = "editProfile".localized
    static let changeProfilePhoto = "changeProfilePhoto".localized
    static let nickname = "nickname".localized
    static let introduction = "introduction".localized
    static let school = "school".localized
    static let verify = "verify".localized
    static let verificationFinished = "verificationFinished".localized
    static let genreOfInterest = "genreOfInterest".localized
    static let change = "change".localized
    static let applyCertifiedAuthor = "applyCertifiedAuthor".localized
    // 프로필 탭 버튼
    static let scrapList = "scrapList".localized // 스크랩 목록
    static let requestList = "requestList".localized // 의뢰해요
    static let salesList = "salesList".localized // 판매 작품
    static let workList = "workList".localized // 작업해요
    // 검색
    static let workRequestSearchPlaceholder = "workRequestSearchPlaceholder".localized
    static let recentQuery = "recentQuery".localized
    static let removeAll = "removeAll".localized
    
    // 판매글쓰기
    // - 카테고리 선택
    static let categorySelection = "categorySelection".localized
    static let pleaseSelectGenre = "pleaseSelectGenre".localized
    static let sellingArtwork = "sellingArtwork".localized
    static let request = "request".localized
    static let work = "work".localized
    static let pleaseSelectCategoryUptoThree = "pleaseSelectCategoryUptoThree".localized
    // - 사진등록
    static let addPhotos = "addPhotos".localized
    static let uploadPhotos = "uploadPhotos".localized
    static let thumbnail = "thumbnail".localized
    // - 작품정보
    static let artworkInfo = "artworkInfo".localized
    static let artworkTitle = "artworkTitle".localized
    static let price = "price".localized
    static let krw = "krw".localized
    static let getPriceOffer = "getPriceOffer".localized
    static let artworkDescriptionPlaceholder = "artworkDescriptionPlaceholder".localized
    static let artworkDescription = "artworkDescription".localized
    // - 의뢰내용
    static let requestContent = "requestContent".localized
    static let requestTitle = "requestTitle".localized
    static let requestContentPlaceholder = "requestContentPlaceholder".localized
    // - 작품사이즈
    static let artworkSizeOptional = "artworkSizeOptional".localized
    static let pleaseApproxSizeOfArtwork = "pleaseApproxSizeOfArtwork".localized
    static let width = "width".localized // 가로
    static let height = "height".localized // 세로
    static let depth = "depth".localized // 높이
    static let detailSize = "detailSize".localized
    // 프로덕트 상세
    static let scrap = "scrap".localized // 찜하기
    static let askDeal = "askDeal".localized // 거래 문의하기
    static let sendPriceOffer = "sendPriceOffer".localized // 가격 제안하기
    static let notAllowedPriceOffer = "notAllowedPriceOffer".localized // 가격 제안 불가
    // 가격 제안하기/받기
    static let priceOffer = "priceOffer".localized // 가격제안
    static let pleaseOfferPriceMatchesMarket = "pleaseOfferPriceMatchesMarket".localized // 시세에 맞는 가격을 제안해보세요.
    static let currentBestPrice = "currentBestPrice".localized // 현재 최고 금액
    static let canOnlyMakeOneSuggestionPerPost = "canOnlyMakeOneSuggestionPerPost".localized // 게시글 당 1회만 제안이 가능해요
    static let fromNim = "fromNim".localized
    static let suggestedPriceOffer = "suggestedPriceOffer".localized //  님께서 가격을 제안하셨어요.
    static let suggest = "suggest".localized // 제안하기
    static let accept = "accept".localized // 수락하기
    static let decline = "decline".localized // 거절하기
    // 웰컴 스크린
    static let welcome = "welcome".localized
    static let welcomeDescription = "welcomeDescription".localized
    static let letsGoSeeArtworks = "letsGoSeeArtworks".localized
    // 설정
    static let setting = "setting".localized
    // - 섹션 타이틀
    static let personalSetting = "personalSetting".localized
    static let usageGuide = "usageGuide".localized
    static let etcSection = "etcSection".localized
    // - 섹션 내용
    static let linkedAccounts = "linkedAccounts".localized
    static let blockedUser = "blockedUser".localized
    static let appVersion = "appVersion".localized
    static let ask = "ask".localized
    static let notice = "notice".localized
    static let termsOfService = "termsOfService".localized
    static let privacyPolicy = "privacyPolicy".localized
    static let opensourceLicense = "opensourceLicense".localized
    static let withdraw = "withdraw".localized
    static let logout = "logout".localized
}
