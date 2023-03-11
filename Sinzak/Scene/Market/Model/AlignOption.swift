//
//  AlignOption.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/29.
//

import Foundation

enum AlignOption: String, CaseIterable {
    case recommend
    case popular
    case recent
    case low
    case high

    var text: String {
        switch self {
        case .recommend:
            return "신작추천순"
        case .popular:
            return "인기순"
        case .recent:
            return "최신순"
        case .low:
            return "낮은가격순"
        case .high:
            return "높은가격순"
        }
    }
    var descriptionText: String? {
        switch self {
        case .recommend:
            return "작품 클릭 수, 작품 좋아요 수, 작가\n판매 실적 등을 기준으로 정합니다. "
        case .popular:
            return "작품 인기도, 작가의 팔로워, 찜하기\n등을 기준으로 정합니다."
        default:
            return nil
        }
    }
}
