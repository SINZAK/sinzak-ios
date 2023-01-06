//
//  Genre.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/06.
//

import Foundation

struct Genre {
    let type: String
    let category: [String]
}

// 회원가입 관심장르
extension Genre {
    static let list: [Genre] = [
        Genre(type: I18NStrings.fineart,
              category: [
                I18NStrings.painting,
                I18NStrings.orientalPainting,
                I18NStrings.sculpture,
                I18NStrings.print,
                I18NStrings.craft,
                I18NStrings.portrait,
                I18NStrings.etc
              ]
             ),
        Genre(type: I18NStrings.design,
              category: [
                I18NStrings.illust,
                I18NStrings.packageLabel,
                I18NStrings.printDesign,
                I18NStrings.posterBannerSign,
                I18NStrings.logoBranding,
                I18NStrings.appWebDesign
              ]
             )
    ]
}
