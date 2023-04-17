//
//  Genre.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/06.
//

import Foundation
import RxSwift
import RxDataSources

struct Genre {
    let type: String
    let category: [AllGenre]
}

enum AllGenre: String {
    case painting
    case orient
    case sculpture
    case print
    case craft
    
    case portrait
    case illustration
    case logo
    case poster
    case design
    case editorial
    case label
    
    var text: String {
        switch self {
        case .painting:
            return I18NStrings.painting
        case .orient:
            return I18NStrings.orientalPainting
        case .sculpture:
            return I18NStrings.sculpture
        case .print:
            return I18NStrings.print
        case .craft:
            return I18NStrings.craft
        case .portrait:
            return I18NStrings.portrait
        case .illustration:
            return I18NStrings.illust
        case .label:
            return I18NStrings.packageLabel
        case .editorial:
            return I18NStrings.printDesign
        case .poster:
            return I18NStrings.posterBannerSign
        case .logo:
            return I18NStrings.logoBranding
        case .design:
            return I18NStrings.appWebDesign
        }
    }
}

// 회원가입 관심장르
extension Genre {
    
    static let fineArtList: Genre = Genre(
        type: I18NStrings.fineart,
        category: [
            .painting,
            .orient,
            .sculpture,
            .print,
            .craft
        ])
    
    static let desingList: Genre = Genre(
        type: I18NStrings.design,
        category: [
            .portrait,
            .illustration,
            .logo,
            .poster,
            .design,
            .editorial,
            .label
        ])
}

struct AllGenreDataSection {
    let header: String
    var items: [AllGenre]
}

extension AllGenreDataSection: SectionModelType {
    typealias Item = AllGenre
    
    init(original: AllGenreDataSection, items: [AllGenre]) {
        self = original
        self.items = items
    }
}
