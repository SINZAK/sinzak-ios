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
