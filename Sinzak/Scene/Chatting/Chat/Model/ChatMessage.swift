//
//  ChatMessage.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/30.
//

import Foundation

enum MessageType: String {
    case text = "TEXT"
    case image = "IMAGE"
    case leave = "LEAVE"
}

struct ChatMessage {
    var senderID: Int
    var messageID: Int
    var message: String
    var senderName: String
    var sendAt: String
    var messageType: MessageType
    
    init(
        senderID: Int,
        messageID: Int,
        message: String,
        senderName: String,
        sendAt: String,
        messageType: String
    ) {
        self.senderID = senderID
        self.messageID = messageID
        self.message = message
        self.senderName = senderName
        self.sendAt = sendAt
        self.messageType = MessageType(rawValue: messageType) ?? .text
    }
    
    init() {
        self.senderID = -1
        self.messageID = -1
        self.message = ""
        self.senderName = ""
        self.sendAt = ""
        self.messageType = .text
    }
}
