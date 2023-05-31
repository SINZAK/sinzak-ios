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
        "Authorization": KeychainItem.currentAccessToken, // 키체인에서 불러온 Auth 토큰
        "hear-beat": "0,30000"
    ]

    /// 소켓 연결
    func registerSocket() {
        socketClient.openSocketWithURLRequest(
            request: NSURLRequest(url: url!),
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

    func subscribe(roomID: String) {
        let destination = "/sub/chat/rooms/\(roomID)"
        if socketClient.isConnected() {
            Log.debug("Stomp subscribe \(roomID)")
            socketClient.subscribe(destination: destination)
        }
    }

    func unsubscribe(roomID: String) {
        let destination = "/sub/chat/rooms/\(roomID)"
        if socketClient.isConnected() {
            socketClient.unsubscribe(destination: destination)
        }
    }

    /// 메시지 전송
//    func sendMessage(message: Message) {
//        socketClient.sendJSONForDict(
//            dict: message.nsDictionary,
//            toDestination: "/pub/chat/message"
//        )
//    }

    func leaveChatroom(roomId: String) {
        let leave = Leave(roomId: roomId)
        socketClient.sendJSONForDict(
            dict: leave.nsDictionary,
            toDestination: "/pub/chat/leave"
        )
    }

    func sendPing() {

    }

}

extension StompManager: StompClientLibDelegate {
    func stompClientDidConnect(client: StompClientLib!) {
        Log.debug("Stomp is connected successfully!")
    }

    func stompClientDidDisconnect(client: StompClientLib!) {
        Log.debug("Stomp is Disconnected")
    }

    func stompClient(
        client: StompClientLib!,
        didReceiveMessageWithJSONBody jsonBody: AnyObject?,
        akaStringBody stringBody: String?,
        withHeader header: [String: String]?,
        withDestination destination: String
    ) {
        print("DESTINATION: \(destination)")
        print("JSON BODY: \(String(describing: jsonBody))")
        print("STRING BODY: \(stringBody ?? "nil")")

        if let data = stringBody?.data(using: String.Encoding.utf8) {
            let message = try? JSONDecoder().decode(ChatMessageDTO.self, from: data)
            Log.debug(message?.toDomain())
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
