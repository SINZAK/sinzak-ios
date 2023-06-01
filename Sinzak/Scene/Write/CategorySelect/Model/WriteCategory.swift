//
//  WriteCategory.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import Foundation

enum WriteCategory: CaseIterable {
    case sellingArtwork
    case request
    case work
    var text: String {
        switch self {
        case .sellingArtwork: return "작품 판매"
        case .request: return "의뢰해요"
        case .work: return "작업해요"
        }
    }
    var image: String {
        switch self {
        case .sellingArtwork: return "heart3d"
        case .request: return "linkchain"
        case .work: return "paintbucket"
        }
    }
    
    var item: Int {
        switch self {
        case .sellingArtwork:     return 0
        case .request:     return 1
        case .work:        return 2
        }
    }
}
