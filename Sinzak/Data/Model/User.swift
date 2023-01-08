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
/// 회원가입 모델 
struct JoinUser: Codable {
    // properties
    let category_like: String
    let email: String
    let name: String
    let nickName: String
    let origin: String
    let term: Bool
    let tokenId: String
    // initializer
    init(category_like: String, email: String, name: String, nickName: String, origin: SNS, term: Bool, tokenId: String = "") {
        self.category_like = category_like
        self.email = email
        self.name = name
        self.nickName = nickName
        self.origin = origin.rawValue
        self.term = term
        self.tokenId = tokenId
    }
}
