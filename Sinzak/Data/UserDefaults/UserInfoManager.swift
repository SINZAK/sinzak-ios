//
//  UserInfoManager.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/22.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    var wrappedValue: T {
        get { UserDefaults.standard.object(forKey: self.key) as? T ?? self.defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: self.key) }
    }
}

final class UserInfoManager {
    
    static var shared = UserInfoManager()
    
    var profile: Profile {
        get {
            return Profile(
                userID: UserInfoManager.userID,
                myProfile: UserInfoManager.myProfile,
                name: UserInfoManager.name,
                introduction: UserInfoManager.introduction,
                portFolioURL: UserInfoManager.portFolioURL,
                followingNumber: String(UserInfoManager.followingNumber),
                followerNumber: String(UserInfoManager.followerNumber),
                imageURL: UserInfoManager.imageURL,
                univ: UserInfoManager.univ,
                categoryLike: UserInfoManager.categoryLike,
                certUni: UserInfoManager.certUni,
                certAuthor: UserInfoManager.certAuthor,
                follow: UserInfoManager.follow
            )
        }
    }
    
    var works: [MarketProduct] = []
    var workEmploys: [MarketProduct] = []
    var products: [MarketProduct] = []
    
    private init() {}
    
    // MARK: - Profile
    @UserDefault(key: UserManagerKey.userID.rawValue, defaultValue: -1)
    static var userID: Int
    
    @UserDefault(key: UserManagerKey.myProfile.rawValue, defaultValue: true)
    static var myProfile: Bool
    
    @UserDefault(key: UserManagerKey.name.rawValue, defaultValue: "")
    static var name: String
    
    @UserDefault(key: UserManagerKey.introduction.rawValue, defaultValue: "")
    static var introduction: String
    
    @UserDefault(key: UserManagerKey.portFolioURL.rawValue, defaultValue: "")
    static var portFolioURL: String
    
    @UserDefault(key: UserManagerKey.followingNumber.rawValue, defaultValue: -1)
    static var followingNumber: Int
    
    @UserDefault(key: UserManagerKey.followerNumber.rawValue, defaultValue: -1)
    static var followerNumber: Int
    
    @UserDefault(key: UserManagerKey.imageURL.rawValue, defaultValue: "")
    static var imageURL: String
    
    @UserDefault(key: UserManagerKey.univ.rawValue, defaultValue: "")
    static var univ: String
    
    @UserDefault(key: UserManagerKey.categoryLike.rawValue, defaultValue: "")
    static var categoryLike: String
    
    @UserDefault(key: UserManagerKey.certUni.rawValue, defaultValue: false)
    static var certUni: Bool
    
    @UserDefault(key: UserManagerKey.certAuthor.rawValue, defaultValue: false)
    static var certAuthor: Bool
    
    @UserDefault(key: UserManagerKey.follow.rawValue, defaultValue: false)
    static var follow: Bool
    
    }

extension UserInfoManager {
    
    func saveUserInfo(with userInfo: UserInfo) {
        let profile = userInfo.profile
        UserInfoManager.userID = profile.userID ?? -1
        UserInfoManager.myProfile = profile.myProfile ?? false
        UserInfoManager.name = profile.name ?? ""
        UserInfoManager.introduction = profile.introduction ?? ""
        UserInfoManager.portFolioURL = profile.portFolioURL ?? ""
        UserInfoManager.followingNumber = Int(profile.followingNumber ?? "0")!
        UserInfoManager.followerNumber = Int(profile.followerNumber ?? "0")!
        UserInfoManager.imageURL = profile.imageURL ?? ""
        UserInfoManager.univ = profile.univ ?? ""
        UserInfoManager.categoryLike = profile.categoryLike ?? ""
        UserInfoManager.certUni = profile.certUni ?? false
        UserInfoManager.certAuthor = profile.certAuthor ?? false
        UserInfoManager.follow = profile.follow ?? false
        
        UserInfoManager.shared.products = userInfo.products ?? []
        UserInfoManager.shared.works = userInfo.works ?? []
        UserInfoManager.shared.workEmploys = userInfo.workEmploys ?? []
        
        logUserInfo()
    }
    
    func logout() {
        UserManagerKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
        UserInfoManager.shared.products = []
        UserInfoManager.shared.works = []
        UserInfoManager.shared.workEmploys = []
    }
    
    func logUserInfo() {
        let log = """
        
        -------------------- ✨ User Info Log ✨ --------------------
        Profile: \(UserInfoManager.shared.profile)
        Products: \(UserInfoManager.shared.products)
        Works: \(UserInfoManager.shared.works)
        Work Employs: \(UserInfoManager.shared.workEmploys)
        ----------------------- ✨ End Log ✨ -----------------------
        """
        Log.debug(log)
    }

}

enum UserManagerKey: String, CaseIterable {
    case userID
    case myProfile
    case name
    case introduction
    case portFolioURL
    case followingNumber
    case followerNumber
    case imageURL
    case univ
    case categoryLike
    case certUni
    case certAuthor
    case follow
}