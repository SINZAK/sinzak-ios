//
//  ManagerType.swift
//  Sinzak
//
//  Created by JongHoon on 2023/05/02.
//

import Foundation
import Moya

protocol ManagerType {
    associatedtype Target: TargetType
    var provider: MoyaProvider<Target> { get }
}

extension ManagerType {
    func filterError<T>(_ response: BaseDTO<T>) throws -> BaseDTO<T> {
        if response.success {
            return response
        } else {
            if let message = response.message {
                throw APIError.errorMessage(message)
            } else {
                throw APIError.unknown(nil)
            }
        }
    }
    
    func getData<T>(_ response: BaseDTO<T>) throws -> T {
        guard let data = response.data else { throw APIError.noContent }
        return data
    }
}
