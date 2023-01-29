//
//  WorksCategory.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/29.
//

import Foundation

enum WorksCategory: CaseIterable {
    case all, portrait, illust, logo
    case poster, design, editorial, label, other
    var text: String {
        switch self {
        case .all:
            return "전체"
        case .portrait:
            return "초상화"
        case .illust:
            return "일러스트"
        case .logo:
            return "로고/브랜딩"
        case .poster:
            return "포스터/배너/간판"
        case .design:
            return "앱/웹 디자인"
        case .editorial:
            return "인쇄물"
        case .label:
            return "패키지/라벨"
        case .other:
            return "기타"
        }
    }
}
