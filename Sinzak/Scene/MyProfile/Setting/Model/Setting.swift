//
//  File.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/18.
//

enum Setting: CaseIterable {
    case personalSetting
    case usageGuide
    case etc
    
    var text: String {
        switch self {
        case .personalSetting:
            return "개인 설정"
        case .usageGuide:
            return "이용 안내"
        case .etc:
            return "기타"
        }
    }
    var content: [String] {
        switch self {
        case .personalSetting:
            return [
                "연결된 계정"
//                I18NStrings.blockedUser
            ]
        case .usageGuide:
            return [
                "앱 버전",
                "문의하기",
                "공지사항",
                "서비스 이용약관",
                "개인정보 처리방침"
//                I18NStrings.opensourceLicense
            ]
        case .etc:
            return [
                "회원 탈퇴",
                "로그아웃"
            ]
        }
    }
}
