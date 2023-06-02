//
//  HomeSection.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/07.
//

import Foundation

enum HomeNotLoggedInType: Int, CaseIterable {
    case trading = 3
    case new = 1
    case hot = 2
    var title: String {
        switch self {
        case .trading:
            return "지금 거래중"
        case .new:
            return "최신 작품"
        case .hot:
            return "신작에서 사랑받는 작품"
        }
    }
}

enum HomeLoggedInType: Int, CaseIterable {
    case new = 1
    case recommend = 2
    case following = 3
    var title: String {
        switch self {
        case .new:
            return "최신 작품"
        case .recommend:
            return "\(UserInfoManager.name ?? "") "+"님을 위한 맞춤 거래"
        case .following:
            return "내가 팔로잉하는 작가"
        }
    }
}
