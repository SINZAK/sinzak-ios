//
//  ChatListVM.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/28.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

protocol ChatListVMInput {
    
}

protocol ChatListVMOutput {
    
}

protocol ChatListVM: ChatListVMInput, ChatListVMOutput {}

final class DefaultChatListVM: ChatListVM {
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Input
    
    // MARK: - Output
    
}
