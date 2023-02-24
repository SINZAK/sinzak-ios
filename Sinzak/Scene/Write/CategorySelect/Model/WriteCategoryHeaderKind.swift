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
            return I18NStrings.pleaseSelectGenre
        case .selectCategory:
            return I18NStrings.pleaseSelectCategoryUptoThree
        }
    }
}
