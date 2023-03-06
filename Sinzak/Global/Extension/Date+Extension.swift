//
//  Date+Extension.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/07.
//

import Foundation

// 상대시간 계산하기
extension Date {
    /// 오늘 날짜를 기준으로 상대시간을 계산하여 문자열로 반환한다.
    /// - 예: 12시간 전, 10분 전
    func toRelativeString() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateTimeStyle = .named
        formatter.unitsStyle = .short
        let dateToString = formatter.localizedString(for: self, relativeTo: .now)
        return dateToString
    }
}
