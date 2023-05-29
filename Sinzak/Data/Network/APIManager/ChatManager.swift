//
//  ChatManager.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/28.
//

import Foundation
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
}
