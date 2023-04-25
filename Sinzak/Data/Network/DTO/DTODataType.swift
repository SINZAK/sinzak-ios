//
//  DTODataType.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/25.
//

import Foundation

protocol DTODataType: Codable {
    associatedtype Entity
    
    func toDomain() -> Entity
}
