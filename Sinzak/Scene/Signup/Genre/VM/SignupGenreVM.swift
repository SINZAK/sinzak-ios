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
    func tapInterestedGenreCell(genres: [AllGenre])
    func tapNextButton()
}

protocol SignupGenreVMOutput {
    var allGenreSections: BehaviorRelay<[AllGenreDataSection]> { get }
    var selectedGenre: BehaviorRelay<[AllGenre]> { get }
    var pushUniversityInfoView: PublishRelay<UniversityInfoVC> { get }
}

protocol SignupGenreVM: SignupGenreVMInput, SignupGenreVMOutput {}

final class DefaultSignupGenreVM: SignupGenreVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    func tapInterestedGenreCell(genres: [AllGenre]) {
        selectedGenre.accept(genres)
    }
    
    func tapNextButton() {
        let vc = UniversityInfoVC(viewModel: DefaultUniversityInfoVM())
        pushUniversityInfoView.accept(vc)
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
}
