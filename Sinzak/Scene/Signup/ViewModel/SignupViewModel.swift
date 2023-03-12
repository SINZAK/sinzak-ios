//
//  SignupViewModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/12.
//

import Foundation
import RxSwift
import Moya

final class SignupViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var joinInfo = Join(categoryLike: [], nickname: "", term: false)
    let manager = AuthManager.shared
    
    func checkNickname(for nickname: String) -> Bool {
        var bool = false
        manager.checkNickname(for: nickname) { result in
           bool = result
        }
        return bool
    }
    struct Input {
        
    }
    struct Output {
        
    }
    func transform(input: Input) -> Output {
        return Output()
    }

}
