//
//  Leave.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/04.
//

import Foundation

struct Leave {
    var roomId: String
    var dictionary: [String: Any] {
        return [
                 "roomId": roomId
            ]
    }

    var nsDictionary: NSDictionary{
        return dictionary as NSDictionary
    }
}
