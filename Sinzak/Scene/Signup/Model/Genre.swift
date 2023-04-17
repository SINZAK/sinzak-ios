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
    case orientalPainting
    case sculpture
    case print
    case craft
    case portrait
    case etc
    case illust
    case packageLagel
    case printDesign
    case posterBannerSign
    case logobranding
    case appWebDesign
    
    var text: String {
        switch self {
        case .painting:
            return I18NStrings.painting
        case .orientalPainting:
            return I18NStrings.orientalPainting
        case .sculpture:
            return I18NStrings.sculpture
        case .print:
            return I18NStrings.print
        case .craft:
            return I18NStrings.craft
        case .portrait:
            return I18NStrings.portrait
        case .etc:
            return I18NStrings.etc
        case .illust:
            return I18NStrings.illust
        case .packageLagel:
            return I18NStrings.packageLabel
        case .printDesign:
            return I18NStrings.printDesign
        case .posterBannerSign:
            return I18NStrings.posterBannerSign
        case .logobranding:
            return I18NStrings.logoBranding
        case .appWebDesign:
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
            .orientalPainting,
            .sculpture,
            .print,
            .craft,
            .portrait,
            .etc
        ])
    
    static let desingList: Genre = Genre(
        type: I18NStrings.design,
        category: [
            .illust,
            .packageLagel,
            .printDesign,
            .posterBannerSign,
            .logobranding,
            .appWebDesign
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
