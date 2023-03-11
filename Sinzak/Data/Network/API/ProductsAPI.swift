//
//  ProductsAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/03.
//

import Foundation
import Moya

enum ProductsAPI {
    case products(align: String, page: Int, size: Int, category: String, sale: Bool)
}

extension ProductsAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .products:
            return "/products"
        }
    }
    var method: Moya.Method {
        switch self {
        case .products:
            return .post
        }
    }
    var task: Moya.Task {
        switch self {
        case .products(let align, let page, let size, let category, let sale):
            let param: [String: Any] = [
                "align": align,
                "categories": category,
                "page": page,
                "sale": sale,
                "size": size
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        }
    }
    var headers: [String: String]? {
        let header = [
            "Content-type": "application/json"
        ]
        let accessToken = KeychainItem.currentAccessToken
        switch self {
        case .products:
            var header = header
            if !accessToken.isEmpty {
                header["Authorization"] = accessToken
            }
            return header
        }
    }
}
