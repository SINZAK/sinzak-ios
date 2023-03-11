//
//  ProductsAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/03.
//

import Foundation
import Moya

enum ProductsAPI {
    // 조회
    case products(align: String, page: Int, size: Int, category: String, sale: Bool)
    case productDetail(id: Int)
    // 게시글 작성, 수정
    case build
    case edit
    case delete
    case imageUpload
    // 게시글 액션
    case likes
    case sell
    case suggest
    case wish
}

extension ProductsAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .products:
            return "/products"
        case .productDetail(let id):
            return "/products/\(id)"
        }
    }
    var method: Moya.Method {
        switch self {
        default:
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
        case .productDetail:
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
            var header = header
            if !accessToken.isEmpty {
                header["Authorization"] = accessToken
            }
            return header
        }
    }
}
