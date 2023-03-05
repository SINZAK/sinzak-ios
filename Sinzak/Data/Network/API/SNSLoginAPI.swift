//
//  SNSLoginAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/05.
//

import Foundation
import Moya

enum SNSLoginAPI {
    case apple(idToken: String, origin: String = "apple")
}

extension SNSLoginAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .apple:
            return "/oauth/get"
        }
    }
    var method: Moya.Method {
        switch self {
        case .apple: return .post
        }
    }
    var task: Task {
        switch self {
        case .apple(let idToken, let origin):
            let params: [String: String] = [
                "idToken": idToken,
                "origin": origin
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }
    var headers: [String : String]? {
        switch self {
        case .apple:
            return ["Content-type": "application/json"]
        }
    }
}
