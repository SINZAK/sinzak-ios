//
//  ChatRoomDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/28.
//

import Foundation

struct ChatRoomDTO: Codable {
    var roomUuid: String?
    var image: String?
    var roomName: String?
    var univ: String?
    var latestMessage: String?
    var latestMessageTime: String?
    
    func toDomain() -> ChatRoom {
        return ChatRoom(
            roomUUID: roomUuid ?? "-1",
            image: image ?? "",
            roomName: roomName ?? "",
            univ: univ ?? "",
            latestMessage: latestMessage ?? "",
            latestMessageTime: latestMessageTime ?? ""
        )
    }
}
