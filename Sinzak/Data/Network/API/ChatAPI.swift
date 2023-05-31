//
//  ChatAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/04.
//

import UIKit
import Moya

enum ChatAPI {
    // 채팅방 조회
    case fetchChatRoomList // 챗룸 리스트
    case fetchPostChatRoomList(postID: Int, postType: String)
    
    case chatRoom(uuid: String) // 특정 챗룸 정보 조회
    case chatRoomMessages(uuid: String, page: Int) // 메시지 조회
    // 채팅방 생성, 이미지 업로드
    
    case checkChatRoom(postID: Int, postType: String)
    case chatCreate(postId: Int, postType: String)
    case chatRoomImageUpload(uuid: String, images: [UIImage])
}

extension ChatAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .fetchChatRoomList:
            return "/chat/rooms"
        case .fetchPostChatRoomList:
            return "/chat/rooms/post"
        case .chatRoom(let uuid):
            return "/chat/rooms/\(uuid)"
        case .chatRoomMessages(let uuid, _):
            return "/chat/rooms/\(uuid)/message"
        case .checkChatRoom:
            return "/chat/rooms/check"
        case .chatCreate:
            return "/chat/rooms/create"
        case .chatRoomImageUpload(let uuid, _):
            return "/chat/rooms/\(uuid)/image"
        }
    }
    var method: Moya.Method {
        switch self {
        case .chatRoomMessages:
            return .get
        default:
            return .post
        }
    }
    var task: Moya.Task {
        switch self {
        case .fetchChatRoomList, .chatRoom:
            return .requestPlain
        case let .fetchPostChatRoomList(postID, postType):
            let params: [String: Any] = [
                "postId": postID,
                "postType": postType
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case let .chatRoomMessages(_, page):
            let params: [String: Any] = [
                "page": page
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.queryString
            )
        case .chatRoomImageUpload(_, let images):
            var formData: [MultipartFormData] = []
            for image in images {
                if let imageData = image.jpegData(compressionQuality: 0.3) {
                    let name = String.uniqueFilename(withPrefix: "IMAGE")
                    formData.append(MultipartFormData(
                        provider: .data(imageData),
                        name: "multipartFile",
                        fileName: "\(name).jpeg",
                        mimeType: "image/jpeg"
                    ))
                }
            }
            return .uploadMultipart(formData)
        case .checkChatRoom(postID: let postID, postType: let postType):
            let params: [String: Any] = [
                "postId": postID,
                "postType": postType
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .chatCreate(postId: let postId, postType: let postType):
            let params: [String: Any] = [
                "postId": postId,
                "postType": postType
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)        }
    }
    var headers: [String: String]? {
        let header = [
            "Content-type": "application/json",
        ]
        let accessToken = KeychainItem.currentAccessToken
        switch self {
        case .chatRoomImageUpload:
            var header = [String: String]()
            header["Authorization"] = accessToken
            return header 
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
