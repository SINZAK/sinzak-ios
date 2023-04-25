//
//  DTOBase.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/25.
//

import Foundation

struct BaseDTO<D: DTODataType>: Codable {
    var data: D?
    var success: Bool
    var message: String?
}
