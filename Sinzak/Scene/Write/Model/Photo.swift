//
//  Photo.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/18.
//

import UIKit
import Differentiator

struct Photo: IdentifiableType, Equatable {
    let image: UIImage
    var identity = UUID().uuidString
}
