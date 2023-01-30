//
//  HomeViewModel.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/30.
//

import Foundation

class HomeViewModel: ViewModelType {
    let networkManager = HomeManager.shared
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
}
