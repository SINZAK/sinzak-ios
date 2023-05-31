//
//  CreateChatRoomDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/06/01.
//

import Foundation

struct CreateChatRoomDTO: Codable {
    let roomUuid: String
    let newChatRoom: Bool
}
