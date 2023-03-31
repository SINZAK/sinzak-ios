//
//  ProductsAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/03.
//

import UIKit
import Moya

enum ProductsAPI {
    // 조회
    case products(align: String, page: Int, size: Int, category: String, sale: Bool)
    case productDetail(id: Int)
    // 홈 섹션별
    case homeFollowing
    case homeProducts
    case homeRecommend
    // 게시글 작성, 수정
    case build(post: MarketBuild) // 판매글 생성
    case edit(id: Int, editPost: MarketBuildEdit)
    case delete(id: Int)
    case deleteImage(id: Int, url: String) // 이미지삭제
    case imageUpload(id: Int, images: [UIImage])
    // 좋아요, 찜
    case like(id: Int, mode: Bool)
    case wish(id: Int, mode: Bool)
    // 판매, 가격제안
    case sell(postId: Int)
    case priceSuggest(id: Int, price: Int)
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
        case .homeFollowing:
            return "/home/following"
        case .homeProducts:
            return "/home/products"
        case .homeRecommend:
            return "/home/recommend"
        case .build:
            return "/products/build"
        case .edit(let id, _):
            return "/products/\(id)/edit"
        case .delete(let id):
            return "/products/\(id)/delete"
        case .deleteImage(let id, _):
            return "/products/\(id)/deleteimage"
        case .imageUpload(let id, _):
            return "/products/\(id)/image"
        case .like:
            return "/products/likes"
        case .wish:
            return "/products/wish"
        case .sell:
            return "/products/sell"
        case .priceSuggest:
            return "/products/suggest"
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
            let sale: String = sale ? "true" : "false"
            let param: [String: Any] = [
                "align": align,
                "categories": category,
                "page": "0...\(page)",
                "sale": sale,
                "size": size
            ]
            
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            
        case .build(let post):
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(post)
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
            } catch {
                print("Error encoding userInfo: \(error)")
                return .requestPlain
            }
        case .edit(_, let editPost):
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(editPost)
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
            } catch {
                print("Error encoding userInfo: \(error)")
                return .requestPlain
            }
        case .deleteImage(_, let url):
            let param: [String: Any] = [
                "url": url
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .imageUpload(_, let images):
            var formData: [MultipartFormData] = []
            for image in images {
                if let imageData = image.jpegData(compressionQuality: 0.6) {
                    let name = String.uniqueFilename(withPrefix: "IMAGE")
                    formData.append(MultipartFormData(
                        provider: .data(imageData),
                        name: name,
                        fileName: "\(name).jpg"
                    ))
                }
            }
            return .uploadMultipart(formData)
        case .like(let id, let mode), .wish(let id, let mode):
            let param: [String: Any] = [
                "id": id,
                "mode": mode
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            
        case .sell(let postId):
            let param: [String: Any] = [
                "postId": postId
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
        case .priceSuggest(let id, let price):
            let param: [String: Any] = [
                "id": id,
                "price": price
            ]
            return .requestParameters(parameters: param, encoding: URLEncoding.queryString)
            
        case .productDetail, .homeProducts, .homeFollowing, .homeRecommend, .delete:
            return .requestPlain
        }
    
    }
    var headers: [String: String]? {
        let header = [
            "Content-type": "application/json"
        ]
        let accessToken = KeychainItem.currentAccessToken
        switch self {
        case .imageUpload:
            var header = ["Content-Type": "multipart/form-data; boundary=<calculated when request is sent>" ]
            header["Authorization"] = accessToken
            return header 
        default:
            var header = header
            if !accessToken.isEmpty {
                header["Authorization"] = accessToken
            }
            return header
        }
    }
}
