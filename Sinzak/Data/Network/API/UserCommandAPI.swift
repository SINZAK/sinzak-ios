//
//  UserCommandAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/01.
//

import Foundation
import Moya

enum UserCommandAPI {
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
        
    case report(userId: Int, reason: String) // 신고
    
    // 팔로우
    case follow(userId: Int)
    case unfollow(userId: Int)
}

extension UserCommandAPI: TargetType {
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
        case .report(userId: _, reason: _):
            return "/users/report"
        case .follow:
            return "/users/follow"
        case .unfollow:
            return "/users/unfollow"
        }
    }
    var method: Moya.Method {
        switch self {
        case .report(userId: _, reason: _), .follow(userId: _), .unfollow(userId: _):
            return .post
        default:
            return .get
        }
    }
    var task: Moya.Task {
        switch self {
        case let .report(userId, reason):
            let params: [String: Any] = [
                "userId": userId,
                "reason": reason
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case .follow(let userId), .unfollow(let userId):
            let params: [String: Any] = [
                "userId": userId
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
    var headers: [String: String]? {
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
                print("액세스토큰이 없어 불가능합니다.")
                return header
            }
        }
    }
}
