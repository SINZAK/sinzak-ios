//
//  ProfileVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/08.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol ProfileVMInput {
    func fetchMyProfile()
    func fetchOthersProfile(userID: Int)
    func followButtonTapped(isFollowing: Bool)
}

protocol ProfileVMOutput {
    var userInfoRelay: PublishRelay<UserInfo> { get }
    var showSkeleton: PublishRelay<Bool> { get }
    var isFollowRelay: PublishRelay<Bool> { get }
    var followingCountRelay: BehaviorRelay<String> { get }
}

protocol ProfileVM: ProfileVMInput, ProfileVMOutput {}

final class DefaultProfileVM: ProfileVM {
    
    private let disposeBag = DisposeBag()
    
    var userInfo: UserInfo?
    
    // MARK: - Input
    
    func fetchMyProfile() {
        UserQueryManager.shared.fetchMyProfile()
            .subscribe(
                with: self,
                onSuccess: { owner, userInfo in
                    owner.userInfoRelay.accept(userInfo)
                },
                onFailure: { _, error in
                    Log.error(error)
                })
            .disposed(by: disposeBag)
    }
    
    func fetchOthersProfile(userID: Int) {
        UserQueryManager.shared.fetchOthersProfile(userID: userID)
            .subscribe(
                with: self,
                onSuccess: { owner, userInfo in
                    owner.userInfoRelay.accept(userInfo)
                    owner.followingCountRelay.accept(userInfo.profile.followingNumber)
                    owner.userInfo = userInfo
                    
                },
                onFailure: { _, error in
                    Log.error(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    func followButtonTapped(isFollowing: Bool) {
        guard let userInfo = userInfo else { return }
        
        switch isFollowing {
        case true:
            UserCommandManager.shared.unfollow(userId: userInfo.profile.userID)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    with: self,
                    onSuccess: { owner, _ in
                        owner.isFollowRelay.accept(false)
                        if let currentFollowingCount = Int(owner.followingCountRelay.value) {
                            owner.followingCountRelay.accept(String(currentFollowingCount - 1))
                        }
                    },
                    onFailure: { _, error  in
                        Log.error(error)
                    })
                .disposed(by: disposeBag)
        case false:
            UserCommandManager.shared.follow(userId: userInfo.profile.userID)
                .observe(on: MainScheduler.instance)
                .subscribe(
                    with: self,
                    onSuccess: { owner, _ in
                        owner.isFollowRelay.accept(true)
                        if let currentFollowingCount = Int(owner.followingCountRelay.value) {
                            owner.followingCountRelay.accept(String(currentFollowingCount + 1))
                        }
                    },
                    onFailure: { _, error  in
                        Log.error(error)
                    })
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Output
    
    var userInfoRelay: PublishRelay<UserInfo> = .init()
    var showSkeleton: PublishRelay<Bool> = .init()
    var isFollowRelay: PublishRelay<Bool> = .init()
    var followingCountRelay: BehaviorRelay<String> = .init(value: "0")
}
