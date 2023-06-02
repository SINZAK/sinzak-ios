//
//  UserCommandAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/03/01.
//

import UIKit
import Moya

enum UserCommandAPI {
    // 모든 사용자보기
    // case allUsers
    // 사용자
    case myProfile
    case myWishlist
    case myWorklist
    case mySearchHistory
    
    // 사용자 정보 수정
    case editUserImage(image: UIImage, isIcon: Bool)
    case editUserInfo(userInfo: UserInfoEdit)
    case editGenre(genres: String)
    
    // 다른 사람 조회
    case otherProfile(userId: Int)
    case otherFollowing(userId: Int)
    case otherFollower(userId: Int)
        
    // 신고
    case report(userId: Int, reason: String)
    
    // 팔로우
    case follow(userId: Int)
    case unfollow(userId: Int)
    
    // FCM
    case saveFCM(userID: Int, fcmToken: String)
}

extension UserCommandAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .myProfile:
            return "/users/my-profile"
        case .myWishlist:
            return "/users/wish"
        case .myWorklist:
            return "/users/work-employ"
        case .mySearchHistory:
            return "/users/history"
        case .editUserImage:
            return "/users/edit/image"
        case .editUserInfo:
            return "/users/edit"
        case .otherProfile(let userId):
            return "/users/\(userId)/profile"
        case .otherFollowing(let userId):
            return "/users/\(userId)/followings"
        case .otherFollower(let userId):
            return "/users/\(userId)/followers"
        case .report(userId: _, reason: _):
            return "/users/report"
        case .follow:
            return "/users/follow"
        case .unfollow:
            return "/users/unfollow"
        case .editGenre(_):
            return "/users/edit/category"
        case .saveFCM:
            return "/users/fcm"
        }
    }
    var method: Moya.Method {
        switch self {
        case .report,
                .follow,
                .unfollow,
                .editGenre,
                .editUserImage,
                .editUserInfo,
                .saveFCM:
            return .post
        default:
            return .get
        }
    }
    var task: Moya.Task {
        switch self {
        case let .report(userId, reason):
            let params: [String: Any] = [
                "userId": userId,
                "reason": reason
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case let .editUserImage(image, isIcon):
            
            var formData: [MultipartFormData] = []
            let imageName = String.uniqueFilename(withPrefix: "IMAGE")
            var imageData: Data
            
            switch isIcon {
            case true:
                imageData = image.pngData() ?? Data()
                formData.append(
                    MultipartFormData(
                        provider: .data(imageData),
                        name: "multipartFile",
                        fileName: "\(imageName).png",
                        mimeType: "image/png"
                    ))
                return .uploadMultipart(formData)
                
            case false:
                imageData = image.jpegData(compressionQuality: 0.3) ?? Data()
                formData.append(
                    MultipartFormData(
                        provider: .data(imageData),
                        name: "multipartFile",
                        fileName: "\(imageName).jpeg",
                        mimeType: "image/jpeg"
                    ))
                return .uploadMultipart(formData)
            }
            
        case .editUserInfo(let userInfo):
            
            var param: [String: Any] = [
                "introduction": userInfo.introduction
            ]
            
            if UserInfoManager.name != userInfo.name {
                param["name"] = userInfo.name
            }
            
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)

        case .follow(let userId), .unfollow(let userId):
            let params: [String: Any] = [
                "userId": userId
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            
        case let .editGenre(genres):
            let params: [String: Any] = [
                "categoryLike": genres
            ]
            return .requestParameters(
                parameters: params,
                encoding: JSONEncoding.default
            )
        case let .saveFCM(userID, fcmToken):
            let params: [String: Any] = [
                "userId": userID,
                "fcmToken": fcmToken
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.queryString
            )
        default:
            return .requestPlain
        }
    }
    var headers: [String: String]? {
        let header = [
            "Content-type": "application/json"
        ]
        switch self {
        case .saveFCM:
            return header
        default:
            let accessToken = KeychainItem.currentAccessToken
            if !accessToken.isEmpty {
                var header = header
                header["Authorization"] = accessToken
                return header
            } else {
                print("액세스토큰이 없어 불가능합니다.")
                return header
            }
        }
    }
}
