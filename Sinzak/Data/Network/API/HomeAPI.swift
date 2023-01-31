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
}

extension HomeAPI: TargetType {
    
    
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .banner:
            return "/banner"
        }
    }
    var method: Moya.Method {
        switch self {
        case .banner:
            return .get
        }
    }
    var task: Moya.Task {
        switch self {
        case .banner:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    
}
