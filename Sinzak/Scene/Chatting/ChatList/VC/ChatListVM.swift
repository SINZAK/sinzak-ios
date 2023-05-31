//
//  ChatListVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/28.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias ChatRoomSectionModel = SectionModel<Void, ChatRoom>

protocol ChatListVMInput {
    func fetchChatList()
    func fetchPostChatList(postID: Int, type: String)
}

protocol ChatListVMOutput {
    var chatRoomSectionModel: BehaviorRelay<[ChatRoomSectionModel]> { get }
}

protocol ChatListVM: ChatListVMInput, ChatListVMOutput {}

final class DefaultChatListVM: ChatListVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    func fetchChatList() {
        ChatManager.shared.fetchChatList()
            .subscribe(
                with: self,
                onSuccess: { owner, chatRooms in
                    let chatRoomSectionModel = ChatRoomSectionModel(
                        model: Void(),
                        items: chatRooms
                    )
                    owner.chatRoomSectionModel.accept([chatRoomSectionModel])
                })
            .disposed(by: disposeBag)
    }
    
    func fetchPostChatList(postID: Int, type: String) {
        ChatManager.shared.fetchPostChatList(postID: postID, postType: type)
            .subscribe(
                with: self,
                onSuccess: { owner, chatRooms in
                    let chatRoomSectionModel = ChatRoomSectionModel(
                        model: Void(),
                        items: chatRooms
                    )
                    owner.chatRoomSectionModel.accept([chatRoomSectionModel])
                })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    
    var chatRoomSectionModel: BehaviorRelay<[ChatRoomSectionModel]> = .init(value: [])
    
}
