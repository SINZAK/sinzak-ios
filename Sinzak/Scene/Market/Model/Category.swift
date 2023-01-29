//
//  Category.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/27.
//

import Foundation

enum Category: CaseIterable {
    case all
    case painting
    case orient
    case sculpture
    case print
    case craft
    case other
    var text: String {
        switch self {
        case .all:
            return "전체"
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
        case .other:
            return "기타"
        }
    }
}
