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
}

protocol SignupGenreVMOutput {
    var allGenreSections: BehaviorRelay<[AllGenreDataSection]> { get }
    var selectedGenre: BehaviorRelay<[AllGenre]> { get }
}

protocol SignupGenreVM: SignupGenreVMInput, SignupGenreVMOutput {}

final class DefaultSignupGenreVM: SignupGenreVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    func tapInterestedGenreCell(genres: [AllGenre]) {
        selectedGenre.accept(genres)
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
}
