//
//  AuthAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/08.
//

import Foundation
import Moya

enum AuthAPI {
    case checkemail(email: String)
    case signup(userInfo: JoinUser)
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .checkemail:
            return "/checkemail"
        case .signup:
            return "/join"
        }
    }
    var method: Moya.Method {
        switch self {
        case .checkemail:
            return .post
        case .signup:
            return .post
        }
    }
    var task: Task {
        switch self {
        case .checkemail(let email):
            let params: [String: String] = [
                "email": email
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .signup(let userInfo):
            let params: [String: Any] = [
                "category_like": userInfo.category_like,
                "email": userInfo.email,
                "name": userInfo.name,
                "nickName": userInfo.nickName,
                "origin": userInfo.origin,
                "term": userInfo.term,
                "tokenId": userInfo.tokenId
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    var headers: [String : String]? {
        switch self {
        case .checkemail(_):
            return ["Content-type": "application/json"]
        case .signup(_):
            return ["Content-type": "application/json"]
        }
        
    }
}
