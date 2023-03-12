//
//  ChatAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/04.
//

import Foundation
import Moya

enum ChatAPI {
    case chatRoomList // 챗룸 리스트
    case chatRoom(uuid: String) // 특정 챗룸 정보 조회
    case chatRoomMessages(uuid: String) // 메시지 조회
    case allChatRoomForPost(postId: Int, postType: String)
}

extension ChatAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .chatRoomList:
            return "/chat/rooms"
        case .chatRoom(let uuid):
            return "/chat/rooms/\(uuid)"
        case .chatRoomMessages(let uuid):
            return "/chat/rooms/\(uuid)/message"
        case .allChatRoomForPost:
            return "/chat/rooms/post"
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
        case .chatRoomList, .chatRoom, .chatRoomMessages:
            return .requestPlain
        case .allChatRoomForPost(let postId, let postType):
            let params: [String: Any] = [
                "postId": postId,
                "postType": postType
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    var headers: [String : String]? {
        let header = [
            "Content-type": "application/json",
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
