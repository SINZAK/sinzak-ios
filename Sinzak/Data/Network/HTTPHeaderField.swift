//
//  HTTPHeaderField.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/15.
//

import Foundation


enum HeaderField: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}

enum ContentType: String {
    case json = "application/json"
    case multipart = "multipart/form-data; boundary=<calculated when request is sent>"
}

extension HeaderField {
    static var header: [String:String] {
        var header: [String:String] = [:]
        header[HeaderField.contentType.rawValue] = ContentType.json.rawValue
        header[HeaderField.authorization.rawValue] = KeychainItem.currentAccessToken
        return header
    }
}
