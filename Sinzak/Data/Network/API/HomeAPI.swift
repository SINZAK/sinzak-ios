//
//  HomeAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/30.
//

import Foundation
import Moya

enum HomeAPI {
    case banner
    case homeNotLogined
    case homeLogined
}

extension HomeAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .banner:
            return "/banner"
        case .homeNotLogined, .homeLogined:
            return "/home/products"
        }
    }
    var method: Moya.Method {
        switch self {
        case .banner:
            return .get
        case .homeNotLogined, .homeLogined:
            return .post
        }
    }
    var task: Moya.Task {
        switch self {
        case .banner:
            return .requestPlain
        case .homeNotLogined, .homeLogined:
            return .requestPlain
        }
    }
    var headers: [String: String]? {
        let header = [
            "Content-type": "application/json"
        ]
        let accessToken = KeychainItem.currentAccessToken
        switch self {
        case .banner, .homeNotLogined:
            return header
        case .homeLogined:
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
