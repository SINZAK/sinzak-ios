//
//  UserAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/01.
//

import Foundation
import Moya

enum UserAPI {
    // 모든 사용자보기
    // case allUsers
    // 사용자
    case myProfile
    case myWishlist
    case myWorklist
    case mySearchHistory
    // 다른 사람 조회
    case otherProfile(userId: Int)
    case otherFollowing(userId: Int)
    case otherFollower(userId: Int)
}

extension UserAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .myProfile:
            return "/users/my-profile"
        case .myWishlist:
            return "/users/wish"
        case .myWorklist:
            return "/users/work-employ"
        case .mySearchHistory:
            return "/users/history"
        case .otherProfile(let userId):
            return "/users/\(userId)/profile"
        case .otherFollowing(let userId):
            return "/users/\(userId)/followings"
        case .otherFollower(let userId):
            return "/users/\(userId)/followers"
        }
    }
    var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    var task: Moya.Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    var headers: [String : String]? {
        let header = [
            "Content-type": "application/json",
        ]
        let accessToken = KeychainItem.currentAccessToken
        switch self {
        default:
            if !accessToken.isEmpty {
                var header = header
                header["Authorization"] = accessToken
                return header
            } else {
                print("액세스토큰이 없어 불가능합니다.")
                return header
            }
        }
    }
}
