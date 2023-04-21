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

struct OnboardingUser {
    var accesToken: String?
    var refreshToken: String?
    var nickname: String?
    var categoryLike: [String]?
    var term: Bool?
    
    init() {
        self.accesToken = nil
        self.refreshToken = nil
        self.nickname = nil
        self.categoryLike = nil
        self.term = nil
    }
}

struct Join: Codable {
    var categoryLike, nickname: String
    var term: String
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
        self.term = term ? "true" : "false"
    }
}
// MARK: - 사용자 정보 수정
struct UserInfoEdit: Codable {
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
