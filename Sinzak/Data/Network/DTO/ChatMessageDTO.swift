//
//  ChatMessageDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/30.
//

import Foundation

struct ChatMessageContentDTO: Codable {
    var content: [ChatMessageDTO]?
    var success: Bool?
    var message: String?
}

struct ChatMessageDTO: Codable {
    var senderId: Int?
    var messageId: Int?
    var message: String?
    var senderName: String?
    var sendAt: String?
    var messageType: String?
    
    func toDomain() -> ChatMessage {
        return ChatMessage(
            senderID: senderId ?? -1,
            messageID: messageId ?? -1,
            message: message ?? "",
            senderName: senderName ?? "",
            sendAt: sendAt ?? "",
            messageType: messageType ?? "TEXT"
        )
    }
}
