//
//  ChatRoomInfoDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/30.
//

import Foundation

struct ChatRoomInfoDTO: Codable {
    var roomName: String?
    var postId: Int?
    var postName: String?
    var price: Int?
    var thumbnail: String?
    var complete: Bool?
    var suggest: Bool?
    var postUserId: Int?
    var postType: String?
    var opponentUserId: Int?
    
    func toDomain() -> ChatRoomInfo {
        return ChatRoomInfo(
            roomName: roomName ?? "",
            postId: postId,
            postName: postName ?? "",
            price: price ?? -1,
            thumbnail: thumbnail ?? "",
            complete: complete ?? true,
            suggest: suggest ?? false,
            postUserId: postUserId ?? -1,
            postType: postType ?? "",
            opponentUserId: opponentUserId ?? -1
        )
    }
}
