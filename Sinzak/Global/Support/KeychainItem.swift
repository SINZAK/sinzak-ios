//
//  KeychainItem.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/02/12.
//

import Foundation

/// 제네릭 패스워드 키체인 아이템에 접근하기 위한 구조체
struct KeychainItem {
    // MARK: - Types
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unexpectedItemData
        case unhandledError
    }
    // MARK: - Properties
    let service: String
    private(set) var account: String
    let accessGroup: String?
    
    // MARK: - Init
    init(service: String,
         account: String,
         accessGroup: String? = nil) {
        self.service = service
        self.account = account
        self.accessGroup = accessGroup
    }
    // MARK: Keychain access
    /// 아이템 읽어오기
    func readItem() throws -> String {
        // 서비스, 어카운트, 액세스그룹과 일치하는 아이템을 찾는 쿼리를 작성
        var query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        query[kSecReturnData as String] = kCFBooleanTrue
        
        // 기존 키체인 아이템 중에 쿼리와 일치하는 아이템을 가져오기
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        // 리턴 상태 체크 후, 필요한 경우 에러 발생
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == noErr else { throw KeychainError.unhandledError }
        
        // 쿼리 결과에서 비밀번호 문자열 파싱
        guard let existingItem = queryResult as? [String: AnyObject],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
            else {
                throw KeychainError.unexpectedPasswordData
        }
        
        return password
    }
    /// 아이템 저장하기
    func saveItem(_ password: String) throws {
        // 비밀번호를 Data Object로 인코딩
        let encodedPassword = password.data(using: String.Encoding.utf8)!
        
        do {
            // 키체인에 이미 있는 항목인지 체크
            try _ = readItem()
            
            // 이미 있을 경우 기존아이템을 새 비밀번호로 업데이트
            var attributesToUpdate = [String: AnyObject]()
            attributesToUpdate[kSecValueData as String] = encodedPassword as AnyObject?
            
            let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            
            // 예상에 없는 상태가 반환될 경우 에러 발생
            guard status == noErr else { throw KeychainError.unhandledError }
        } catch KeychainError.noPassword {
            /**
             키체인에 패스워드가 없음. 새 키체인 아이템을 저장하기 위해 딕셔너리 생성
             */
            var newItem = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
            newItem[kSecValueData as String] = encodedPassword as AnyObject?
            
            // 키체인에 새 아이템 추가
            let status = SecItemAdd(newItem as CFDictionary, nil)
            
            // 에러 핸들링
            guard status == noErr else { throw KeychainError.unhandledError }
        }
    }
    /// 아이템 제거
    func deleteItem() throws {
        // 기존 아이템을 키체인에서 제거
        let query = KeychainItem.keychainQuery(withService: service, account: account, accessGroup: accessGroup)
        let status = SecItemDelete(query as CFDictionary)
        
        // 에러핸들링
        guard status == noErr || status == errSecItemNotFound else { throw KeychainError.unhandledError }
    }
    
    // MARK: - Convenience
    private static func keychainQuery(withService service: String, account: String? = nil, accessGroup: String? = nil) -> [String: AnyObject] {
        var query = [String: AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrService as String] = service as AnyObject?
        if let account = account {
            query[kSecAttrAccount as String] = account as AnyObject?
        }
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup as AnyObject?
        }
        return query
    }
    
    /**
     디바이스 키체인에 userIdentifier 저장. 추후 서버단으로 변경
     */
    static var currentUserIdentifier: String {
        do {
            let storedIdentifier = try KeychainItem(service: "com.kimdee.Sinzak", account: "userIdentifier").readItem()
            return storedIdentifier
        } catch {
            return ""
        }
    }
    static func deleteUserIdentifierFromKeychain() {
        do {
            try KeychainItem(service: "com.kimdee.Sinzak", account: "userIdentifier").deleteItem()
        } catch {
            print("키체인에서 userIdentifier를 제거할 수 없습니다.")
        }
    }
}
