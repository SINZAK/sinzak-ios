//
//  Message.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/04.
//

import Foundation

enum MessageType {
    case TEXT
    case IMAGE
    
    var text: String {
        switch self {
        case .TEXT: return "TEXT"
        case .IMAGE: return "IMAGE"
        }
    }
}
/// 전달하는 메시지
struct Message {
    var message: String
    var senderName: String
    var roomId: String
    var senderId: Int
    var messageType: MessageType = .TEXT
    var dictionary: [String: Any] {
        return ["message": message,
                "senderName": senderName,
                "roomId": roomId,
                "senderId": senderId,
                "messageType": messageType.text
        ]
    }
    var nsDictionary: NSDictionary{
        return dictionary as NSDictionary
    }
}
// socketClient.sendJSONForDict(dict: message.nsDictionary, toDestination: "/pub/chat/message")

