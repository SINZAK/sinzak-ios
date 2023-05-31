//
//  ChatManager.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/28.
//

import UIKit
import Moya
import RxSwift

final class ChatManager: ManagerType {
    
    static var shared = ChatManager()
    private init() {}
    
    let provider = MoyaProvider<ChatAPI>(
        callbackQueue: .global(),
        plugins: [MoyaLoggerPlugin.shared]
    )
    
    func fetchChatList() -> Single<[ChatRoom]> {
        return provider.rx.request(.chatRoomList)
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<[ChatRoomDTO]>.self)
            .map(filterError)
            .map(getData)
            .map { $0.map { $0.toDomain() } }
    }
    
    func getChatRoomInfo(roomID: String) -> Single<ChatRoomInfo> {
        return provider.rx.request(.chatRoom(uuid: roomID))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<ChatRoomInfoDTO>.self)
            .map(filterError)
            .map(getData)
            .map { $0.toDomain() }
    }
    
    func getChatRoomMessage(roomID: String, page: Int) -> Single<[ChatMessage]> {
        return provider.rx.request(.chatRoomMessages(
            uuid: roomID,
            page: page
        ))
        .filterSuccessfulStatusCodes()
        .map(ChatMessageContentDTO.self)
        .map { chatMessageContentDTO in
            if chatMessageContentDTO.success == false {
                Log.error(chatMessageContentDTO.message ?? "")
                throw APIError.errorMessage(chatMessageContentDTO.message ?? "")
            }
            
            let content = chatMessageContentDTO.content ?? []
            let messages = content.map { $0.toDomain() }
            
            return messages
        }
    }
    
    func uploadImage(roomID: String, images: [UIImage]) -> Single<[String]> {
        return provider.rx.request(.chatRoomImageUpload(uuid: roomID, images: images))
            .filterSuccessfulStatusCodes()
            .map(BaseDTO<[URLDTO]>.self)
            .map(filterError)
            .map(getData)
            .map { urls in
                return urls.map { $0.url }
            }
    }
}
