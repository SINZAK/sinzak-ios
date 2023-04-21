//
//  MoyaLoggerPlugin.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/21.
//

import Foundation
import Moya

final class MoyaLoggerPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        guard let httpRequest = request.request else {
            Log.error("유효하지 않은 요청입니다.")
            return
        }
        let url = httpRequest.url?.description ?? ""
        let method = httpRequest.method?.rawValue ?? ""
        var log = "----------------------- ✨ API Log ✨ -----------------------\n"
        log.append("[Will Send]")
        log.append("✨ URL: \(url)\n")
        log.append("✨ METHOD: \(method)\n")
        log.append("✨ API: \(target)\n")
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
            // TODO: 토큰 리프레쉬 작업 추가
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
    }
    
    func onFail(_ error: MoyaError, target: TargetType) {
        
        let request = error.response?.request
        let url = request?.url?.absoluteString ?? ""
        let statusCode = error.response?.statusCode ?? 0
        let errorDescription = error.errorDescription ?? ""
        
        let log = """
            ----------------------- ✨ API Log ✨ -----------------------
            [Did Receive - Failure]
            ✨ API: \(target)
            ✨ URL: \(url)
            ✨ STATUS CODE: \(statusCode)
            ✨ ERROR: \(error)
            ✨ ERROR Description: \(errorDescription)
            ----------------------- ✨ End Log ✨ -----------------------
            """
        print(log)
    }
    
}
