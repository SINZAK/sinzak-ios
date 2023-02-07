//
//  HomeViewModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/30.
//

import Foundation
import RxSwift

class HomeViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    let networkManager = HomeManager.shared
    struct Input {
    }
    struct Output {
    }

    func transform(input: Input) -> Output {
        return Output()
    }
}
