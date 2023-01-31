//
//  SocketIOManager.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/01.
//

import Foundation
import SocketIO

/// 소켓통신을 담당하는 매니저 클래스
class SocketIOManager {
    static let shared = SocketIOManager()
    // 서버랑 메시지를 주고 받기 위한 클래스
    var manager: SocketManager!
    var socket: SocketIOClient!
    
    private init() {
        manager = SocketManager(socketURL: URL(string: "")!, config: [
            .log(true),
            .extraHeaders(["": ""]) // 서버에 헤더 보내기 (소켓 URL 정보 필요)
        ])
        socket = manager.defaultSocket
        
        // 소켓 연결
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
        }
        // 소켓 연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        // 이벤트 수신
        socket.on("event") { dataArray, ack in
            print("event RECEIVED", dataArray, ack)
        }
    }
    
    /// 소켓 연결 메서드
    func establishConnection() {
        socket.connect()
    }
    /// 소켓 해제 메서드
    func closeConnection() {
        socket.disconnect()
    }
}
