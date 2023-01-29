//
//  ViewModelType.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/26.
//

import Foundation

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
