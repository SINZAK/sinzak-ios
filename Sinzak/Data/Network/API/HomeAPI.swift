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
    // case homeLogined
}

extension HomeAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .banner:
            return "/banner"
        case .homeNotLogined:
            return "/home/products"
        }
    }
    var method: Moya.Method {
        switch self {
        case .banner:
            return .get
        case .homeNotLogined:
            return .post
        }
    }
    var task: Moya.Task {
        switch self {
        case .banner:
            return .requestPlain
        case .homeNotLogined:
            return .requestPlain
        }
    }
    var headers: [String : String]? {
        switch self {
        case .banner:
            return nil
        case .homeNotLogined:
            return nil
        }
    }
}
