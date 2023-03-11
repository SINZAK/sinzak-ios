//
//  ChatAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/04.
//

import Foundation
import Moya

enum ChatAPI {
    case chatRoomList
    case chatRoom(uuid: String)
    case chatRoomMessages(uuid: String)
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
        default:
            return .requestPlain
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
