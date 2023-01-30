//
//  ViewModelType.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/26.
//

import RxSwift
import Foundation

protocol ViewModelType: AnyObject {
    associatedtype Input
    associatedtype Output
    var disposeBag: DisposeBag { get set }
    func transform(input: Input) -> Output
}
