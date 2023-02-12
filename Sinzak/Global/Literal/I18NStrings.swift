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
}
