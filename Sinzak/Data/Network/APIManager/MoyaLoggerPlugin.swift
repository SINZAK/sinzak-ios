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
        log.append("✨ url: \(url)\n")
        log.append("✨ method: \(method)\n")
        log.append("✨ API: \(target)\n")
        if let headers = httpRequest.allHTTPHeaderFields, !headers.isEmpty {
            log.append("✨ header: \(headers)\n")
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
        case .success(_):
            // TODO: 토큰 리프레쉬 작업 추가
            break
        case let .failure(error):
            Log.error(error)
        }
    }
}
