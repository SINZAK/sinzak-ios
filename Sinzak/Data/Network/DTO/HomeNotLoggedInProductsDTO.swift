//
//  HomeNotLoggedInProductsDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/07/12.
//

import Foundation

struct HomeNotLoggedInProductsDTO: Codable {
    let trading, new, hot: [MarketProductResponseDTO]
    
    func toDomain() -> HomeNotLoggedInProducts {
        return HomeNotLoggedInProducts(
            trading: self.trading.map { $0.toDomain() },
            new: self.new.map { $0.toDomain() },
            hot: self.hot.map { $0.toDomain() }
        )
    }
}
