//
//  WorksAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/01.
//

import UIKit
import Moya

enum WorksAPI {
    // 조회
    case works(align: String, page: Int, size: Int, category: String, sale: Bool)
    case worksDetail(id: Int)
    // 게시글 작성, 수정
    case build(post: WorkBuild)
    case edit(id: Int, editPost: WorkBuildEdit)
    case delete(id: Int)
    case deleteImage(id: Int, url: String)
    case imageUpload(id: Int, images: [UIImage])
    // 게시글 액션
    case like(id: Int, mode: Bool)
    case wish(id: Int, mode: Bool)
    case sell(postId: Int) // 모집완료
    case priceSuggest(id: Int, price: Int)
    
}

extension WorksAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .works:
            return "/works"
        case .worksDetail(let id):
            return "/works/\(id)"
        case .build:
            return "/works/build"
        case .edit(let id, _):
            return "/works/\(id)/edit"
        case .delete(let id):
            return "/works/\(id)/delete"
        case .deleteImage(let id, _):
            return "/works/\(id)/deleteimage"
        case .imageUpload(let id, _):
            return "/works/\(id)/image"
        case .like:
            return "/works/likes"
        case .wish:
            return "/works/wish"
        case .sell:
            return "/works/sell"
        case .priceSuggest:
            return "/works/suggest"
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
        case .works(let align, let page, let size, let category, let sale):
            let param: [String: Any] = [
                "align": align,
                "categories": category,
                "page": page,
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
            
        case .worksDetail, .delete:
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
