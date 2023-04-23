//
//  AppleAuthAPI.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/23.
//

import Foundation
import Moya
import SwiftKeychainWrapper

enum AppleAuthAPI {
    case refreshToken(accessToken: String)
    case revoke
}

extension AppleAuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://appleid.apple.com")!
    }
    
    var path: String {
        switch self {
        case .refreshToken:        return "/auth/token"
        case .revoke:              return "/auth/revoke"
        }
    }
    
    var method: Moya.Method {
        switch self {
        default:                   return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .refreshToken:
            let code = KeychainWrapper.standard.string(forKey: AppleAuth.appleAuthCode.rawValue) ?? ""
            let parameters: [String: Any] = [
                "client_id": "net.sinzak.ios",
                "client_secret": KeychainItem.currentAccessToken,
                "code": code,
                "grant_type": "authorization_code"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .revoke:
            let token = KeychainWrapper.standard.string(forKey: AppleAuth.refresh.rawValue) ?? ""
            let parameters: [String: Any] = [
                "client_id": "net.sinzak.ios",
                "client_secret": KeychainItem.currentAccessToken,
                "token": token
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .refreshToken:
            let header = ["Content-Type": "application/x-www-form-urlencoded"]
            return header
        case .revoke:
            let header = ["Content-Type": "application/x-www-form-urlencoded"]
            return header
        }
    }
}
