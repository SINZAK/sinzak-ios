//
//  WriteCategoryHeaderKind.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/23.
//

import Foundation

enum WriteCategoryHeaderKind: CaseIterable {
    case selectGenre
    case selectCategory
    var text: String {
        switch self {
        case .selectGenre:
            return "분야를 선택해주세요."
        case .selectCategory:
            return "카테고리를 선택해주세요. (최대 3개)"
        }
    }
}
