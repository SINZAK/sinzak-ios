//
//  StompManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/04.
//

import Foundation
import StompClientLib

class StompManager {
    private init() {}
    static let shared: StompManager = StompManager()
    
    private let url = URL(string: Endpoint.wsURL)
    var socketClient = StompClientLib()
    let header = [
        "Authorization": KeychainItem.currentAccessToken // 키체인에서 불러온 Auth 토큰
    ]
    
    /// 소켓 연결
    func registerSocket() {
        socketClient.openSocketWithURLRequest(
            request: NSURLRequest(url: url! as URL),
            delegate: self as StompClientLibDelegate,
            connectionHeaders: header
        )
    }
    
    /// 소켓 연결 해제
    func disconnect() {
        if socketClient.isConnected() {
            socketClient.disconnect()
        }
    }
    
    func subscribe(roomId: String) {
        let destination = "/sub/chat/room/\(roomId)"
        if socketClient.isConnected() {
            socketClient.subscribe(destination: destination)
        }
    }
    
    /// 메시지 전송
    func sendMessage(message: Message) {
        socketClient.sendJSONForDict(
            dict: message.nsDictionary,
            toDestination: "/pub/chat/message"
        )
    }
    
    func leaveChatroom(roomId: String) {
        let leave = Leave(roomId: roomId)
        socketClient.sendJSONForDict(
            dict: leave.nsDictionary,
            toDestination: "/pub/chat/leave"
        )
    }
    
}

extension StompManager: StompClientLibDelegate {
    func stompClient(
        client: StompClientLib!,
        didReceiveMessageWithJSONBody jsonBody: AnyObject?,
        akaStringBody stringBody: String?,
        withHeader header: [String: String]?,
        withDestination destination: String
    ) {
        print("DESTINATION : \(destination)")
        print("JSON BODY : \(String(describing: jsonBody))")
        print("STRING BODY : \(stringBody ?? "nil")")
    }
    
    func stompClientJSONBody(
        client: StompClientLib!,
        didReceiveMessageWithJSONBody jsonBody: String?,
        withHeader header: [String : String]?,
        withDestination destination: String
    ) {
        print("DESTINATION : \(destination)")
        print("String JSON BODY : \(String(describing: jsonBody))")
    }
    
    func stompClientDidDisconnect(client: StompClientLib!) {
        print("Socket is Disconnected")
    }
    
    func stompClientDidConnect(client: StompClientLib!) {
        print("Socket is connected successfully!")
    }
    
    func serverDidSendReceipt(
        client: StompClientLib!,
        withReceiptId receiptId: String
    ) {
        print("Receipt : \(receiptId)")
    }
    
    func serverDidSendError(
        client: StompClientLib!,
        withErrorMessage description: String,
        detailedErrorMessage message: String?
    ) {
        print("Error : \(String(describing: message))")
        // 연결에 실패하였습니다.
    }
    
    func serverDidSendPing() {
        print("Server Ping")
    }
}
