//
//  AuthAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/08.
//

import Foundation
import Moya

enum AuthAPI {
    case join(joinInfo: Join)
    case editUserInfo(userInfo: UserInfo)
    case editCategoryLike(category: CategoryLikeEdit)
    case fcmTokenUpdate(fcmInfo: FCMTokenUpdate)
    case reissue // 토큰 갱신
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .join:
            return "/join"
        case .editUserInfo:
            return "/users/edit"
        case .editCategoryLike:
            return "/users/edit/category"
        case .fcmTokenUpdate:
            return "/users/fcm"
        case .reissue:
            return "/reissue"
        }
    }
    var method: Moya.Method {
        switch self {
        case .join, .editUserInfo, .fcmTokenUpdate, .reissue, .editCategoryLike:
            return .post
        }
    }
    var task: Task {
        switch self {
            case .join(let joinInfo):
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(joinInfo)
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                    return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
                } catch {
                    print("Error encoding userInfo: \(error)")
                    return .requestPlain
                }
        case .editUserInfo(let userInfo):
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(userInfo)
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
            } catch {
                print("Error encoding userInfo: \(error)")
                return .requestPlain
            }
        case .editCategoryLike(let category):
            let params: [String: String] = [
                "categoryLike": category.categoryLike
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .fcmTokenUpdate(let fcmInfo):
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(fcmInfo)
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
            } catch {
                print("Error encoding userInfo: \(error)")
                return .requestPlain
            }
        case .reissue:
            let params: [String: String] = [
                "accessToken": KeychainItem.currentAccessToken,
                "refreshToken": KeychainItem.currentRefreshToken
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    var headers: [String: String]? {
        let header = [
            "Content-type": "application/json",
        ]
        let accessToken = KeychainItem.currentAccessToken
        switch self {
        case .join, .editUserInfo, .fcmTokenUpdate,  .reissue, .editCategoryLike:
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
