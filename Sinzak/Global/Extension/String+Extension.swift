//
//  String+Extension.swift
//  Sinzak
//
//  Created by Doy Kim on 2022/12/13.
//

import UIKit

// 다국어 설정
extension String {
    var localized: String {
        Bundle.main.localizedString(forKey: self, value: nil, table: nil)
    }
    
    func localized(arguments: CVarArg...) -> String{
        String(format: self.localized, arguments: arguments)
    }
}
// 문자열 -> 날짜
extension String {
    func toDate() -> Date {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let validDate = dateFormater.date(from: self) else { return Date() }
        
        return validDate
    }
}
/** 유효성검사를 위한 정규식 정의 */
enum StringPolicy: String {
    case nickname = #"^[가-힣a-zA-Z0-9-._]{2,10}$"# // 한글, 알파벳, 숫자 포함 공백없이 12자 이하, 기호는 - _ . 사용 가능
    case email = #"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])$"#
    case digit = #"^[\d]{1,}$"#  // 숫자만 입력, 사이즈, 가격등에 사용
}

extension String {
    /// 닉네임 유효한지 정규식으로 체크하여 참, 거짓으로 반환
    func isValidString(_ policy: StringPolicy) -> Bool {
        let regex = policy.rawValue
        let test = NSPredicate(format: "SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
}

