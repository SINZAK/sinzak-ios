//
//  SignupViewModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/12.
//

import Foundation
import RxSwift
import RxCocoa
import Moya

final class SignupViewModel: ViewModelType {
    var disposeBag = DisposeBag()
    var joinInfo = Join(categoryLike: [], nickname: "", term: false)
    let manager = AuthManager.shared
    /// 닉네임 체크 메서드
    func checkNickname(for nickname: String) -> Bool {
        var bool = false
        manager.checkNickname(for: nickname) { result in
           bool = result
        }
        return bool
    }
    struct Input {
        let nameText: ControlProperty<String?>
    }
    struct Output {
        let nameValidation: Observable<Bool>
    }
    func transform(input: Input) -> Output {
        let nameValidation = input.nameText
            .orEmpty
            .map { $0.isValidString(.nickname)}
            .share()
        return Output(nameValidation: nameValidation)
    }

}
