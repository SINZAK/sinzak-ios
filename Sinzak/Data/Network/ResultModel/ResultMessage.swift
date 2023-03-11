//
//  ResultMessage.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/10.
//

import Foundation

struct ShortMessageResult: Codable {
    let success: Bool
    let message: String
}
struct OnlySuccess: Codable {
    let success: Bool
}
