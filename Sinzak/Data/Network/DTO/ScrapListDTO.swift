//
//  ScrapListDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/17.
//

import Foundation

struct ScrapListDTO: Codable {
    let workWishes: [MarketProductResponseDTO]
    let productWishes: [MarketProductResponseDTO]
}
