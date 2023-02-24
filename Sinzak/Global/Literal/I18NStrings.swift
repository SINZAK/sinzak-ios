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
    static let yearOfAdmission = "yearOfAdmission".localized
    static let selectYearStudentNumber = "selectYearStudentNumber".localized
    static let selectAcademicStatus = "selectAcademicStatus".localized
    static let enrolled = "enrolled".localized
    static let graduated = "graduated".localized
    static let universityName = "universityName".localized
    static let searchBySchoolName = "searchBySchoolName".localized
    
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
    // 프로필편집
    static let editProfile = "editProfile".localized
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
}
