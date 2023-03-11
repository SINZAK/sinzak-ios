//
//  User.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/08.
//

import Foundation

/// 로그인용 SNS
enum SNS: String {
    case kakao
    case apple
    case google
}
// MARK: - 회원가입 모델
struct Join: Codable {
    let categoryLike, nickname: String
    let term: Bool
    // CodingKeys
    enum CodingKeys: String, CodingKey {
        case categoryLike = "category_like"
        case nickname = "nickName"
        case term
    }
    // Init
    init(categoryLike: [String], nickname: String, term: Bool = true) {
        self.categoryLike = categoryLike.map { $0 }.joined(separator: ",")
        self.nickname = nickname
        self.term = term
    }
}
// MARK: - 사용자 정보 수정
struct UserInfo: Codable {
    let introduction, name, picture: String
}
// MARK: - 관심정보 수정
struct CategoryLikeEdit: Codable {
    let categoryLike: String
    init(categoryLike: [String], nickname: String, term: Bool = true) {
        self.categoryLike = categoryLike.map { $0 }.joined(separator: ",")
    }
}
// MARK: - FCM 토큰 업데이트
struct FCMTokenUpdate: Codable {
    let fcmToken: String
    let userId: Int
}
