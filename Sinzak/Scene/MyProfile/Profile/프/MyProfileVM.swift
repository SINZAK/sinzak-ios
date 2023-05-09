//
//  MyProfileVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol MyProfileVMInput {
    func fetchProfile()
}

protocol MyProfileVMOutput {
    var userInfo: PublishRelay<UserInfo> { get }
    var showSkeleton: PublishRelay<Bool> { get }
}

protocol MyProfileVM: MyProfileVMInput, MyProfileVMOutput {}

final class DefaultMyProfileVM: MyProfileVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    func fetchProfile() {
        UserQueryManager.shared.fetchMyProfile()
            .subscribe(
                with: self,
                onSuccess: { owner, userInfo in
                    owner.showSkeleton.accept(true)
                    
                    owner.userInfo.accept(userInfo)
                },
                onFailure: { _, error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    
    var userInfo: PublishRelay<UserInfo> = .init()
    
    var showSkeleton: PublishRelay<Bool> = .init()
}
