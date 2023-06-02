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
            return "회화일반"
        case .orient:
            return "동양화"
        case .sculpture:
            return "조소"
        case .print:
            return "판화"
        case .craft:
            return "공예"
        case .portrait:
            return "초상화"
        case .illustration:
            return "일러스트"
        case .label:
            return "패키지/라벨"
        case .editorial:
            return "인쇄물"
        case .poster:
            return "포스터/배너/간판"
        case .logo:
            return "로고/브랜딩"
        case .design:
            return "앱/웹 디자인"
        }
    }
}

// 회원가입 관심장르
extension Genre {
    
    static let fineArtList: Genre = Genre(
        type: "순수 예술",
        category: [
            .painting,
            .orient,
            .sculpture,
            .print,
            .craft
        ])
    
    static let desingList: Genre = Genre(
        type: "디자인",
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
