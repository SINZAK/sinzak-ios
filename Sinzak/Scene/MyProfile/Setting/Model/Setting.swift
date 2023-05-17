//
//  File.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/18.
//

enum Setting: CaseIterable {
    case personalSetting
    case usageGuide
    case etc
    
    var text: String {
        switch self {
        case .personalSetting:
            return I18NStrings.personalSetting
        case .usageGuide:
            return I18NStrings.usageGuide
        case .etc:
            return I18NStrings.etcSection
        }
    }
    var content: [String] {
        switch self {
        case .personalSetting:
            return [
                I18NStrings.linkedAccounts
//                I18NStrings.blockedUser
            ]
        case .usageGuide:
            return [
                I18NStrings.appVersion,
                I18NStrings.ask,
                I18NStrings.notice,
                I18NStrings.termsOfService,
                I18NStrings.privacyPolicy,
//                I18NStrings.opensourceLicense
            ]
        case .etc:
            return [
                I18NStrings.withdraw,
                I18NStrings.logout
            ]
        }
    }
}
