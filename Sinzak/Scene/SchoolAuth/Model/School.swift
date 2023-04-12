//
//  School.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/05.
//

import Foundation
import RxDataSources

struct School: Codable {
    let koreanName: String
    let englishName: String
    let email: String
}

struct SchoolList: Codable {
    let school: [School]
}

extension SchoolList {
    static func loadJson(fileName: String = "school") -> SchoolList? {
       let decoder = JSONDecoder()
       guard
            let url = Bundle.main.url(forResource: fileName, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let schoolList = try? decoder.decode(SchoolList.self, from: data)
       else {
            return nil
       }
       return schoolList
    }
}
// 사용예 : SchoolList.loadJson()! 으로 하거나 SchoolList.loadJson()?.school

struct SchoolData {
    let school: School
}

struct SchoolDataSection {
    var items: [SchoolData]
}

extension SchoolDataSection: SectionModelType {
    typealias Item = SchoolData
    
    init(original: SchoolDataSection, items: [SchoolData]) {
        self = original
        self.items = items
    }
}
