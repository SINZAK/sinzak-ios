//
//  MessageSend.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/31.
//

import Foundation

struct MessageSend {
    let message: String
    let senderName: String
    let roomId: String
    let senderId: Int
    let messageType: MessageType
    
    func toDict() -> [String: Any] {
        return [
            "message": message,
            "senderName": senderName,
            "roomId": roomId,
            "senderId": senderId,
            "messageType": messageType.rawValue
        ]
    }
}
