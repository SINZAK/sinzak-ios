//
//  SignupGenreVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/17.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol SignupGenreVMInput {
    func tapNextButton()
    func tapUpdateGenreButton()
}

protocol SignupGenreVMOutput {
    var allGenreSections: BehaviorRelay<[AllGenreDataSection]> { get }
    var selectedGenre: BehaviorRelay<[AllGenre]> { get }
    var pushUniversityInfoView: PublishRelay<UniversityInfoVC> { get }
    
    var completeUpdateGenre: PublishRelay<Bool> { get }
}

protocol SignupGenreVM: SignupGenreVMInput, SignupGenreVMOutput {}

final class DefaultSignupGenreVM: SignupGenreVM {
    
    private let disposeBag = DisposeBag()
    
    private var onboardingUser: OnboardingUser
    
    private var updateGenre: PublishRelay<[AllGenre]>?
    
    init(onboardingUser: OnboardingUser? = nil) {
        self.onboardingUser = onboardingUser ?? OnboardingUser()
    }
    
    convenience init(updateGenre: PublishRelay<[AllGenre]>) {
        self.init()
        self.updateGenre = updateGenre
    }
    
    // MARK: - Input
    
    func tapNextButton() {
        
        KeychainItem.saveTokenInKeychain(
            accessToken: onboardingUser.accesToken ?? "",
            refreshToken: onboardingUser.refreshToken ?? ""
        )

        let join: Join = Join(
            categoryLike: selectedGenre.value.map { $0.rawValue },
            nickname: onboardingUser.nickname ?? "",
            term: onboardingUser.term ?? false
        )
        AuthManager.shared.join(join)
            .observe(on: MainScheduler.instance)
            .subscribe(
                with: self,
                onSuccess: { owner, _ in
                    let vc = UniversityInfoVC(viewModel: DefaultUniversityInfoVM(), mode: .signUp)
                    owner.pushUniversityInfoView.accept(vc)
                    UserQueryManager.shared.fetchMyProfile()
                        .subscribe(
                            onSuccess: { _ in
                                UserCommandManager.shared.getFCMToken()
                                    .subscribe(
                                        onSuccess: { _ in
                                            Log.debug("Save FCM Token Success!")
                                        },
                                        onFailure: { error in
                                            Log.error(error)
                                        })
                                    .disposed(by: owner.disposeBag)
                                Log.debug("회원가입 성공, \(join)")
                                Log.debug("Access Token - \(KeychainItem.currentAccessToken)")
                                Log.debug("Refresh Token - \(KeychainItem.currentRefreshToken)")
                            }, onFailure: { error in
                                Log.error(error)
                            })
                        .disposed(by: owner.disposeBag)
                    
                },
                onFailure: { _, error in
                    APIError.logError(error)
                    KeychainItem.deleteTokenInKeychain()
                })
            .disposed(by: disposeBag)
    }
    
    func tapUpdateGenreButton() {
        let genres = selectedGenre.value
        UserCommandManager.shared.editCategoryLike(genreLikes: genres)
            .subscribe(
                with: self,
                onSuccess: { owner, _ in
                    owner.completeUpdateGenre.accept(true)
                    owner.updateGenre?.accept(genres)
                },
                onFailure: { _, error in
                    Log.error(error)
                }
            )
            .disposed(by: disposeBag)
    }
    
    // MARK: - Output
    let allGenreSections: BehaviorRelay<[AllGenreDataSection]> = .init(value: [

        AllGenreDataSection(
            header: Genre.fineArtList.type,
            items: Genre.fineArtList.category
        ),
        AllGenreDataSection(
            header: Genre.desingList.type,
            items: Genre.desingList.category
        )
    ])
    
    var selectedGenre: BehaviorRelay<[AllGenre]> = .init(value: [])
    var pushUniversityInfoView: PublishRelay<UniversityInfoVC> = .init()
    
    var completeUpdateGenre: PublishRelay<Bool> = .init()
}
