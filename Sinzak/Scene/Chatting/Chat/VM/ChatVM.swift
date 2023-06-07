//
//  ChatVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/30.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

import StompClientLib

typealias MessageSectionModel = SectionModel<Void, ChatMessage>

protocol ChatVMInput {
    func viewDidLoad()
    
    func fetchFirstPageMessage()
    func fetchPreviousMessage()
    
    func startSocketTimer()
    func disconnectSocket()
    func endTimer()
    
    func uploadImage(images: [UIImage])
    func sendTextMessage(message: String)
    func leaveChatRoom()
}

protocol ChatVMOutput {
    var roomID: String { get }
    var roomInfo: ChatRoomInfo? { get }
    
    var artDetailInfo: BehaviorRelay<ChatRoomInfo> { get }
    var messageSectionModels: BehaviorRelay<[MessageSectionModel]> { get }
    var indexPathToScroll: PublishRelay<IndexPath> { get }
    
    var isPossibleFecthPreviousMessage: Bool { get set }
    var popView: PublishRelay<Bool> { get }
    
    var errorHandler: PublishRelay<Error> { get }
}

protocol ChatVM: ChatVMInput, ChatVMOutput {}

final class DefaultChatVM: ChatVM {
    
    // MARK: - Propertied
    
    var roomID: String
    var roomInfo: ChatRoomInfo?
    
    var isPossibleFecthPreviousMessage: Bool = true
    var currentPage: Int = 0
    
    private let url = URL(string: Endpoint.wsURL)
    var socketClient = StompClientLib()
    let header = [
        "Authorization": KeychainItem.currentAccessToken,
        "heart-beat": "0,30000"
    ]
    
    private lazy var timer: Timer = Timer.scheduledTimer(
        withTimeInterval: 40.0,
        repeats: true,
        block: { [weak self] _ in
            Log.debug("ping!")
            guard let self = self else { return }
            if self.socketClient.isConnected() {
                Log.debug("ping 구독 재연결")
                self.subscribeChat()
                self.unsubscribeChat()
            } else {
                Log.debug("ping 소켓 연결")
                self.connectSocket()
            }
        })

    // MARK: - Init
    
    init(roomID: String) {
        self.roomID = roomID
    }
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    func startSocketTimer() {
        timer.fire()
    }
    
    func endTimer() {
        timer.invalidate()
    }
    
    func connectSocket() {
        socketClient.openSocketWithURLRequest(
            request: NSURLRequest(url: url!),
            delegate: self,
            connectionHeaders: header
        )
    }
    
    func disconnectSocket() {
        if socketClient.isConnected() {
            socketClient.disconnect()
        }
    }
    
    func subscribeChat() {
        let destination = "/sub/chat/rooms/\(roomID)"
        if socketClient.isConnected() {
            Log.debug("Stomp subscribe \(roomID)")
            socketClient.subscribe(destination: destination)
        }
    }
    
    func unsubscribeChat() {
        let destination = "/sub/chat/rooms/\(roomID)"
        Log.debug("Stomp unsubscribe")
        if socketClient.isConnected() {
            socketClient.unsubscribe(destination: destination)
        }
    }
    
    func viewDidLoad() {
        ChatManager.shared.getChatRoomInfo(roomID: roomID)
            .subscribe(
                with: self,
                onSuccess: { owner, info in
                    let type = info.postType == "PRODUCT" ? "product" : "work"
                    ChatManager.shared.creatChatRoom(postID: info.postId ?? -1, postType: type)
                        .subscribe(
                            with: self,
                            onSuccess: { owner, _ in
                                owner.roomInfo = info
                                owner.artDetailInfo.accept(info)
                                owner.startSocketTimer()
                                owner.fetchFirstPageMessage()
                            },
                            onFailure: { owner, error in
                                owner.errorHandler.accept(error)
                                owner.roomInfo = info
                                owner.artDetailInfo.accept(info)
                                owner.fetchFirstPageMessage()
                            })
                        .disposed(by: owner.disposeBag)
                },
                onFailure: { owner, error in
                    owner.errorHandler.accept(error)
                })
            .disposed(by: disposeBag)
    }
    
    func fetchChatRoomMessage(page: Int) -> Single<[MessageSectionModel]> {
        return ChatManager.shared.getChatRoomMessage(roomID: roomID, page: page)
            .map { [weak self] messages in
                guard let self = self else { return .init() }
                
                var chatMessages: [ChatMessage] = []
                var sections: [MessageSectionModel] = []
                
                let messages = messages
                    .reversed()
                
                Log.debug(messages)
                
                for message in messages {
                    if chatMessages.isEmpty {
                        chatMessages.append(message)
                        continue
                    }
                    
                    if chatMessages.last?.senderID == message.senderID {
                        chatMessages.append(message)
                        continue
                    } else {
                        
                        let section = MessageSectionModel(
                            model: Void(),
                            items: chatMessages
                        )
                        sections.append(section)
                        chatMessages = [message]
                    }
                }
                
                let section = MessageSectionModel(
                    model: Void(),
                    items: chatMessages
                )
                sections.append(section)
                chatMessages = []
                
                let currentSections = self.messageSectionModels.value
                
                sections.append(contentsOf: currentSections)
                return sections
            }
    }
    
    func fetchFirstPageMessage() {
        fetchChatRoomMessage(page: 0)
            .subscribe(
                with: self,
                onSuccess: { owner, sections in
                
                    owner.messageSectionModels.accept(sections)
                    
                    let indexPath = IndexPath(item: (sections.last?.items.count ?? 0) - 1, section: sections.count - 1)
                    owner.indexPathToScroll.accept(indexPath)
            })
            .disposed(by: disposeBag)
        
    }
    
    func fetchPreviousMessage() {
        guard isPossibleFecthPreviousMessage else { return }
        isPossibleFecthPreviousMessage = false
    
        currentPage += 1
        ChatManager.shared.getChatRoomMessage(roomID: roomID, page: currentPage)
            .subscribe(
                with: self,
                onSuccess: { owner, messages in
                    var chatMessages: [ChatMessage] = []
                    var sections: [MessageSectionModel] = []

                    let messages = messages
                        .reversed()

                    Log.debug(messages)

                    for message in messages {

                        if chatMessages.isEmpty {
                            chatMessages.append(message)
                            continue
                        }

                        if chatMessages.last?.senderID == message.senderID {
                            chatMessages.append(message)
                            continue
                        } else {

                            let section = MessageSectionModel(
                                model: Void(),
                                items: chatMessages
                            )
                            sections.append(section)
                            chatMessages = [message]
                        }
                    }

                    let section = MessageSectionModel(
                        model: Void(),
                        items: chatMessages
                    )
                    sections.append(section)
                    chatMessages = []

                    let currentSections = owner.messageSectionModels.value
                    let indexPath = IndexPath(item: (sections.last?.items.count ?? 0) - 1, section: sections.count - 1)
                    
                    sections.append(contentsOf: currentSections)
                    
                    owner.messageSectionModels.accept(sections)
                    owner.indexPathToScroll.accept(indexPath)
                },
                onFailure: { owner, error in
                    Log.error(error)
                    owner.currentPage = max(0, owner.currentPage-1)
                })
            .disposed(by: disposeBag)

    }
    
    func sendTextMessage(message: String) {
        sendMessage(message: message, type: .text)
    }
    
    func uploadImage(images: [UIImage]) {
        ChatManager.shared.uploadImage(roomID: roomID, images: images)
            .subscribe(
                with: self,
                onSuccess: { owner, imageURLS in
                    for url in imageURLS {
                        Log.debug(url)
                        owner.sendMessage(message: url, type: .image)
                    }
                },
                onFailure: { _, error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
    }
    
    func leaveChatRoom() {
        sendMessage(
            message: "\(UserInfoManager.name ?? "")님이 나가셨습니다.",
            type: .leave
        )
        popView.accept(true)
    }
    
    // MARK: - Output
    
    var artDetailInfo: BehaviorRelay<ChatRoomInfo> = .init(value: ChatRoomInfo(
        roomName: "",
        postName: "",
        price: 0,
        thumbnail: "",
        complete: false,
        suggest: false,
        postUserId: -1,
        postType: "",
        opponentUserId: -1
    ))
    var messageSectionModels: BehaviorRelay<[MessageSectionModel]> = .init(value: [])
    var indexPathToScroll: PublishRelay<IndexPath> = .init()
    var popView: PublishRelay<Bool> = .init()
    var errorHandler: PublishRelay<Error> = .init()
}

extension DefaultChatVM: StompClientLibDelegate {
    func stompClientDidConnect(client: StompClientLib!) {
        Log.debug("Stomp is connected successfully! ✨")
        subscribeChat()
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        connectSocket()
        Log.debug("Stomp is Disconnected ‼️")
    }
    
    func stompClient(
        client: StompClientLib!,
        didReceiveMessageWithJSONBody jsonBody: AnyObject?,
        akaStringBody stringBody: String?,
        withHeader header: [String: String]?,
        withDestination destination: String
    ) {
        
        if let data = stringBody?.data(using: String.Encoding.utf8) {
            let message = try? JSONDecoder().decode(ChatMessageDTO.self, from: data)
            addMessage(newMessage: message?.toDomain() ?? ChatMessage())
        }

    }
    
    func stompClientJSONBody(
        client: StompClientLib!,
        didReceiveMessageWithJSONBody jsonBody: String?,
        withHeader header: [String: String]?,
        withDestination destination: String
    ) {
        print("DESTINATION : \(destination)")
        print("String JSON BODY : \(String(describing: jsonBody))")
    }
    
    func serverDidSendReceipt(
        client: StompClientLib!,
        withReceiptId receiptId: String
    ) {
        print("Receipt: \(receiptId)")
    }
    
    func serverDidSendError(
        client: StompClientLib!,
        withErrorMessage description: String,
        detailedErrorMessage message: String?
    ) {
        Log.error("Stomp Error: \(String(describing: message))")
    }
    
    func serverDidSendPing() {
        print("Server Ping")
    }
}

private extension DefaultChatVM {
    
    func sendMessage(message: String, type: MessageType) {
        let messageSend = MessageSend(
            message: message,
            senderName: UserInfoManager.name ?? "",
            roomId: roomID,
            senderId: UserInfoManager.userID ?? -1,
            messageType: type
        )
        socketClient.sendJSONForDict(
            dict: messageSend.toDict() as AnyObject,
            toDestination: "/pub/chat/message"
        )
    }
    
    func addMessage(newMessage: ChatMessage) {
            
        var currentSections = messageSectionModels.value
        
        if currentSections.last?.items.isEmpty == true {
            let section = MessageSectionModel(
                model: Void(),
                items: [newMessage])
            messageSectionModels.accept([section])
            return
        }
        
        let lastItem = currentSections.last?.items.last ?? ChatMessage()
        
        if lastItem.senderID == newMessage.senderID {
            
            var lastItems = currentSections.last?.items
            lastItems?.append(newMessage)
            currentSections[currentSections.count-1] = MessageSectionModel(
                model: Void(),
                items: lastItems ?? []
            )
            let indexPath = IndexPath(item: (currentSections.last?.items.count ?? 0) - 1, section: currentSections.count - 1)
            
            messageSectionModels.accept(currentSections)
            indexPathToScroll.accept(indexPath)
            return
        } else {
            
            let newSection = MessageSectionModel(
                model: Void(),
                items: [newMessage]
            )
            currentSections.append(newSection)
            let indexPath = IndexPath(item: (currentSections.last?.items.count ?? 0) - 1, section: currentSections.count - 1)
            
            messageSectionModels.accept(currentSections)
            indexPathToScroll.accept(indexPath)
            return
        }
    }
}
