//
//  MoyaLoggerPlugin.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/21.
//

import Foundation
import Moya
import RxSwift

final class MoyaLoggerPlugin: PluginType {
    
    static var shared = MoyaLoggerPlugin()
    private init() {}
    let disposeBag = DisposeBag()
    
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            Log.error("유효하지 않은 요청입니다.")
            return
        }
  
        let url = httpRequest.url?.description ?? ""
        let method = httpRequest.method?.rawValue ?? ""
        var log = "----------------------- ✨ API Log ✨ -----------------------\n"
        log.append("[Will Send]\n")
        log.append("✨ API: \(target)\n")
        log.append("✨ URL: \(url)\n")
        log.append("✨ METHOD: \(method)\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("✨ HEADER: \(headers)\n")
        }
        if let body = httpRequest.httpBody, let bodyString = String(
            bytes: body,
            encoding: String.Encoding.utf8
        ) {
            log.append("\(bodyString)\n")
        }
        log.append("----------------------- ✨ End Log ✨ -----------------------")
        print(log)
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case let .success(response):
            onSucceed(response, target: target)
        case let .failure(error):
            onFail(error, target: target)
        }
    }
}

private extension MoyaLoggerPlugin {
    
    func onSucceed(_ response: Response, target: TargetType) {
        let request = response.request
        let url = request?.url?.absoluteString ?? ""
        let statusCode = response.statusCode
        
        let log = """
            ----------------------- ✨ API Log ✨ -----------------------
            [Did Receive - Success]
            ✨ API: \(target)
            ✨ URL: \(url)
            ✨ STATUS CODE: \(statusCode)
            ----------------------- ✨ End Log ✨ -----------------------
            """
        print(log)
        
        // 토큰이 만료된경우 reissue
        do {
            let message = try JSONDecoder().decode(ShortMessageResult.self, from: response.data)
            if UserInfoManager.isLoggedIn && !message.success && message.message == "로그인이 필요한 작업입니다." {
                AuthManager.shared.reissueForPlugin()
            }
        } catch {
            return
        }
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        
        let request = error.response?.request
        let url = request?.url?.absoluteString ?? ""
        let statusCode = error.response?.statusCode ?? 0
        let errorDescription = error.errorDescription ?? ""
        
        let log = """
            ----------------------- 🚨 API Log 🚨 -----------------------
            [Did Receive - Failure]
            🚨 API: \(target)
            🚨 URL: \(url)
            🚨 STATUS CODE: \(statusCode)
            🚨 ERROR: \(error)
            🚨 ERROR Description: \(errorDescription)
            ----------------------- 🚨 End Log 🚨 -----------------------
            """
        print(log)
    }
}
