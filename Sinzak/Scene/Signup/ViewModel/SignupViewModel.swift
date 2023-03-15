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
    func checkNickname(for nickname: String, completion: @escaping ((Bool) -> ())) {
        manager.checkNickname(for: nickname) { result in
          completion(result)
        }
    }
    struct Input {
        let nameText: ControlProperty<String?>
        let checkButtonTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
    }
    struct Output {
        let nameValidation: Observable<Bool>
        let checkButtonTap: ControlEvent<Void>
        let nextButtonTap: ControlEvent<Void>
    }
    func transform(input: Input) -> Output {
        let nameValidation = input.nameText
            .orEmpty
            .distinctUntilChanged() // 실제 값이 변할때만
            .map { $0.isValidString(.nickname)}
            .share()
        return Output(nameValidation: nameValidation, checkButtonTap: input.checkButtonTap, nextButtonTap: input.nextButtonTap)
    }
}
