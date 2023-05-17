//
//  WriteCategoryVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/06.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

typealias WriteCategorySection = SectionModel<Void, WriteCategory>

typealias GenreSection = SectionModel<Void, GenreItem>

enum GenreItem {
    case products(ProductsCategory)
    case works(WorksCategory)
}

protocol WriteCategoryVMInput {
    func viewDidLoad(initialSelection: WriteCategory)
    func categoryCellTapped(_ category: WriteCategory)
    func genreCellTapped(_ items: [IndexPath])
    
    var selectedCategory: BehaviorRelay<WriteCategory> { get }
    var selectedGenres: BehaviorRelay<[String]> { get }
}

protocol WriteCategoryVMOutput {
    var writeCategorySections: PublishRelay<[WriteCategorySection]> { get }
    var genreSections: PublishRelay<[GenreSection]> { get }
}

protocol WriteCategoryVM: WriteCategoryVMInput, WriteCategoryVMOutput {}

final class DefaultWriteCategoryVM: WriteCategoryVM {
    
    private let disposeBag = DisposeBag()
    
    private let productCategories = Array(ProductsCategory
        .allCases[1..<ProductsCategory.allCases.count])
    
    private let workCategories = Array(WorksCategory
        .allCases[1..<WorksCategory.allCases.count])
    
    // MARK: - Input
    
    func viewDidLoad(initialSelection: WriteCategory) {
        let writeCategorySection = WriteCategorySection(
            model: Void(),
            items: WriteCategory.allCases
        )
        writeCategorySections.accept([writeCategorySection])
        
        categoryCellTapped(initialSelection)
    }
    
    func categoryCellTapped(_ category: WriteCategory) {
        selectedCategory.accept(category)
        
        switch category {
        case .sellingArtwork:
            
            let genreSection = GenreSection(
                model: Void(),
                items: productCategories.map { GenreItem.products($0) }
            )
            genreSections.accept([genreSection])
            
        case .request, .work:
            
            let genreSection = GenreSection(
                model: Void(),
                items: workCategories.map { GenreItem.works($0) }
            )
            genreSections.accept([genreSection])
        }
        
        selectedGenres.accept([])
    }
    
    func genreCellTapped(_ items: [IndexPath]) {
        var selected: [String] = []
        
        switch selectedCategory.value {
        case .sellingArtwork:
            items.forEach {
                selected.append(productCategories[$0.item].rawValue)
            }
            
        case .request, .work:
            items.forEach {
                selected.append(workCategories[$0.item].rawValue)
            }
        }
        
        selectedGenres.accept(selected)
    }

    var selectedCategory: BehaviorRelay<WriteCategory> = .init(value: .sellingArtwork)
    var selectedGenres: BehaviorRelay<[String]> = .init(value: [])
    
    // MARK: - Output
    
    var writeCategorySections: PublishRelay<[WriteCategorySection]> = .init()
    var genreSections: PublishRelay<[GenreSection]> = .init()
}
