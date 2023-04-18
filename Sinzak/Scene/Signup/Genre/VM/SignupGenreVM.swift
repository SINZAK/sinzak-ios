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
    func tapInterestedGenreCell(genres: [String])
    func tapNextButton()
}

protocol SignupGenreVMOutput {
    var allGenreSections: BehaviorRelay<[AllGenreDataSection]> { get }
    var selectedGenre: BehaviorRelay<[String]> { get }
    var pushUniversityInfoView: PublishRelay<UniversityInfoVC> { get }
}

protocol SignupGenreVM: SignupGenreVMInput, SignupGenreVMOutput {}

final class DefaultSignupGenreVM: SignupGenreVM {
    
    private let disposeBag = DisposeBag()
    
    private var onboardingUser: OnboardingUser
    
    init(onboardingUser: OnboardingUser) {
        self.onboardingUser = onboardingUser
    }
    
    // MARK: - Input
    func tapInterestedGenreCell(genres: [String]) {
        selectedGenre.accept(genres)
    }
    
    func tapNextButton() {
        
        KeychainItem.saveTokenInKeychain(
            accessToken: onboardingUser.accesToken ?? "",
            refreshToken: onboardingUser.refreshToken ?? ""
        )

        Log.debug(KeychainItem.currentAccessToken)
        Log.debug(KeychainItem.currentRefreshToken)

        let join: Join = Join(
            categoryLike: selectedGenre.value,
            nickname: onboardingUser.nickname ?? "",
            term: onboardingUser.term ?? false
        )
        AuthManager.shared.join(join)
            .subscribe(
                with: self,
                onSuccess: { owner, _ in
                    let vc = UniversityInfoVC(viewModel: DefaultUniversityInfoVM())
                    owner.pushUniversityInfoView.accept(vc)
                    Log.debug("회원가입 성공, \(join)")
                },
                onFailure: { _, error in
                    APIError.logError(error)
                    KeychainItem.deleteTokenInKeychain()
                })
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
    
    var selectedGenre: BehaviorRelay<[String]> = .init(value: [])
    var pushUniversityInfoView: PublishRelay<UniversityInfoVC> = .init()
}
