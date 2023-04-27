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
    
    init(key: String) {
        self.key = key
    }
    
    var wrappedValue: T? {
        get { UserDefaults.standard.object(forKey: key) as? T }
        set { UserDefaults.standard.set(newValue, forKey: key)}
    }
}

final class UserInfoManager {
    
    static var shared = UserInfoManager()
    
    var profile: Profile {
        get {
            return Profile(
                userID: UserInfoManager.userID ?? -1,
                myProfile: UserInfoManager.myProfile ?? false,
                name: UserInfoManager.name ?? "",
                introduction: UserInfoManager.introduction ?? "",
                portFolioURL: UserInfoManager.portFolioURL ?? "",
                followingNumber: String(UserInfoManager.followingNumber ?? -1),
                followerNumber: String(UserInfoManager.followerNumber ?? -1),
                imageURL: UserInfoManager.imageURL ?? "",
                univ: UserInfoManager.univ ?? "",
                categoryLike: UserInfoManager.categoryLike,
                certUni: UserInfoManager.certUni ?? false,
                certAuthor: UserInfoManager.certAuthor ?? false,
                follow: UserInfoManager.follow ?? false
            )
        }
    }
    
    var works: [Products] = []
    var workEmploys: [Products] = []
    var products: [Products] = []
    
    private init() {}
    
    // MARK: - Profile
    @UserDefault(key: UserManagerKey.userID.rawValue)
    static var userID: Int?
    
    @UserDefault(key: UserManagerKey.myProfile.rawValue)
    static var myProfile: Bool?
    
    @UserDefault(key: UserManagerKey.name.rawValue)
    static var name: String?
    
    @UserDefault(key: UserManagerKey.introduction.rawValue)
    static var introduction: String?
    
    @UserDefault(key: UserManagerKey.portFolioURL.rawValue)
    static var portFolioURL: String?
    
    @UserDefault(key: UserManagerKey.followingNumber.rawValue)
    static var followingNumber: Int?
    
    @UserDefault(key: UserManagerKey.followerNumber.rawValue)
    static var followerNumber: Int?
    
    @UserDefault(key: UserManagerKey.imageURL.rawValue)
    static var imageURL: String?
    
    @UserDefault(key: UserManagerKey.univ.rawValue)
    static var univ: String?
    
    @UserDefault(key: UserManagerKey.categoryLike.rawValue)
    static var categoryLike: String?
    
    @UserDefault(key: UserManagerKey.certUni.rawValue)
    static var certUni: Bool?
    
    @UserDefault(key: UserManagerKey.certAuthor.rawValue)
    static var certAuthor: Bool?
    
    @UserDefault(key: UserManagerKey.follow.rawValue)
    static var follow: Bool?
    
    @UserDefault(key: UserManagerKey.snsKind.rawValue)
    static var snsKind: String?
    
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
        
        let log = """
        \n-------------------- ✨ User Info Log ✨ --------------------
        Profile: \(profile)
        SNS: \(UserInfoManager.snsKind ?? "nil")
        Products: \(UserInfoManager.shared.products)
        Works: \(UserInfoManager.shared.works)
        Work Employs: \(UserInfoManager.shared.workEmploys)
        Access Token: \(KeychainItem.currentAccessToken)
        Refresh Token: \(KeychainItem.currentRefreshToken)
        ----------------------- ✨ End Log ✨ -----------------------
        """
        Log.debug(log)
    }
    
    static var isLoggedIn: Bool {
        
        return !(UserInfoManager.userID == nil)
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
    case snsKind
}
