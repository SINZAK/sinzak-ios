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
    
    var profile: Profile? {
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
    
    var works: [Products] = []
    var workEmploys: [Products] = []
    var products: [Products] = []
    
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
        UserInfoManager.userID = profile.userID
        UserInfoManager.myProfile = profile.myProfile
        UserInfoManager.name = profile.name
        UserInfoManager.introduction = profile.introduction ?? ""
        UserInfoManager.portFolioURL = profile.portFolioURL ?? ""
        UserInfoManager.followingNumber = Int(profile.followingNumber )!
        UserInfoManager.followerNumber = Int(profile.followerNumber )!
        UserInfoManager.imageURL = profile.imageURL ?? ""
        UserInfoManager.univ = profile.univ ?? ""
        UserInfoManager.categoryLike = profile.categoryLike ?? ""
        UserInfoManager.certUni = profile.certUni
        UserInfoManager.certAuthor = profile.certAuthor
        UserInfoManager.follow = profile.follow
        
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
        KeychainItem.deleteTokenInKeychain()
    }
    
    func logUserInfo() {
        
        if let profile = UserInfoManager.shared.profile {
            
            let log = """
        \n-------------------- ✨ User Info Log ✨ --------------------
        Profile: \(profile)
        Products: \(UserInfoManager.shared.products)
        Works: \(UserInfoManager.shared.works)
        Work Employs: \(UserInfoManager.shared.workEmploys)
        Access Token: \(KeychainItem.currentAccessToken)
        Refresh Token: \(KeychainItem.currentRefreshToken)
        ----------------------- ✨ End Log ✨ -----------------------
        """
            Log.debug(log)
        } else {
            Log.debug("로그인된 유저가 없습니다.")
        }
    }

    static var isLoggedIn: Bool {
        return UserInfoManager.userID == -1 ? false : true
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
