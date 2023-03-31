//
//  APIError.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/06.
//

import Foundation

enum APIError: Int, Error {
    case decodingFailed = 999
    case invalidRequest = 400
    case noAuth = 404
    case serverError = 500
}

enum APIErrors: Error {
    case noContent
    case jsonEncoding
    case decodingError
    case unauthorized
    case notAllowedUrl
    case badStatus(code: Int)
    case unknown(_ error: Error?)
    
    var info: String {
        switch self {
        case .noContent:            return "데이터가 없습니다."
        case .jsonEncoding:         return "유효한 json 형식이 아닙니다."
        case .decodingError:        return "디코딩 에러입니다."
        case .unauthorized:         return "인증되지 않은 사용자 입니다."
        case .notAllowedUrl:        return "올바른 URL 형식이 아닙니다."
        case let .badStatus(code):  return "에러 상태코드: \(code)"
        case .unknown(let error):   return "알 수 없는 에러입니다.\n\(String(describing: error))"
        }
    }
    
}
