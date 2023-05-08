//
//  UserQueryAPI.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/08.
//

import Foundation
import Moya

enum UserQueryAPI {
    
    case myProfile // 내 프로필 확인
    
}

extension UserQueryAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL + "/users")!
    }
    
    var path: String {
        switch self {
        case .myProfile:        return "/my-profile"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .myProfile:        return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .myProfile:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        let header = [
            "Content-type": "application/json"
        ]
        let accessToken = KeychainItem.currentAccessToken
        
        switch self {
        default:
            if !accessToken.isEmpty {
                var header = header
                header["Authorization"] = accessToken
                return header
            } else {
                Log.error("액세스토큰이 없어 불가능합니다.")
                return header
            }
        }
    }
}
