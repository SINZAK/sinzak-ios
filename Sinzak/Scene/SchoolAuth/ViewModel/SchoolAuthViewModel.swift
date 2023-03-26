//
//  SchoolAuthViewModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/26.
//

import Foundation
import RxSwift
import RxCocoa

final class SchoolAuthViewModel: ViewModelType {
        var disposeBag = DisposeBag()
    
    struct Input {
        let queryText: ControlProperty<String?>
        let nextButtonTap: ControlEvent<Void>
        let notStudentButtonTap: ControlEvent<Void>
    }
    struct Output {
        let queryText:  Observable<ControlProperty<String>.Element>
        let nextButtonTap: ControlEvent<Void>
        let notStudentButtonTap: ControlEvent<Void>
    }
    func transform(input: Input) -> Output {
        let queryText = input.queryText
            .orEmpty
            .distinctUntilChanged()
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .share()
        
        return Output(queryText: queryText, nextButtonTap: input.nextButtonTap, notStudentButtonTap: input.nextButtonTap)
    }
}
