//
//  HomeLoggedInProductsDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/07/12.
//

import Foundation

struct HomeLoggedInProductsDTO: Codable {
    let new, following, recommend: [MarketProductResponseDTO]
    
    func toDomain() -> HomeLoggedInProducts {
        return HomeLoggedInProducts(
            new: self.new.map { $0.toDomain() },
            following: self.following.map { $0.toDomain() },
            recommend: self.recommend.map { $0.toDomain() }
        )
    }
}
