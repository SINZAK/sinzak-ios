//
//  AuthAPI.swift
//  Sinzak
//
//  Created by Doy Kim on 2023/01/08.
//

import UIKit
import Moya

enum AuthAPI {
    // 가입 및 사용자 프로필 수정
    case nicknameCheck(nickname: String)
    case join(joinInfo: Join)
    case editUserImage(image: UIImage)
    case editUserInfo(userInfo: UserInfo)
    case editCategoryLike(category: CategoryLikeEdit)
    // 액세스토큰, FCM 토큰
    case fcmTokenUpdate(fcmInfo: FCMTokenUpdate) // fcm 토큰 업데이트 ㅡ
    case reissue // 액세스 토큰 갱신
    // 검색기록 삭제
    case deleteSearchHistory // 검색기록 전체 삭제
    case deleteOneHistory(id: Int) // 검색기록 한 개 삭제
    // 팔로우
    case follow(userId: String)
    case unfollow(userId: String)
    // 신고
    case report(reason: String, userId: String) // 신고
    case cancelReport(userId: String) // 신고 취소
    case reportList // 신고목록 보기
    // 탈퇴
    case resign
    
}

extension AuthAPI: TargetType {
    var baseURL: URL {
        return URL(string: Endpoint.baseURL)!
    }
    var path: String {
        switch self {
        case .nicknameCheck:
            return "/check/nickname"
        case .join:
            return "/join"
        case .editUserImage:
            return "/users/edit/image"
        case .editUserInfo:
            return "/users/edit"
        case .editCategoryLike:
            return "/users/edit/category"
        case .fcmTokenUpdate:
            return "/users/fcm"
        case .reissue:
            return "/reissue"
        case .deleteSearchHistory:
            return "/users/deletehistories"
        case .deleteOneHistory:
            return "/users/history"
        case .follow:
            return "/users/follow"
        case .unfollow:
            return "/users/unfollow"
        case .report:
            return "/users/report"
        case .cancelReport:
            return "/users/report/cancel"
        case .reportList:
            return "/users/reportlist"
        case .resign:
            return "/users/resign"
        }
    }
    var method: Moya.Method {
        switch self {
        default:
            return .post
        }
    }
    var task: Task {
        switch self {
            case .nicknameCheck(let nickname):
            let params: [String: String] = [
                "nickName": nickname
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
            case .join(let joinInfo):
                do {
                    let encoder = JSONEncoder()
                    let data = try encoder.encode(joinInfo)
                    let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                    return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
                } catch {
                    print("Error encoding userInfo: \(error)")
                    return .requestPlain
                }
        case .editUserImage(let image):
            var formData: [MultipartFormData] = []
            guard let imageData = image.jpegData(compressionQuality: 0.6) else { return .uploadMultipart(formData)}
            let imageName = String.uniqueFilename(withPrefix: "IMAGE")
            formData.append(MultipartFormData(provider: .data(imageData), name: imageName, fileName: "\(imageName).jpg", mimeType: "image/jpg"))
            return .uploadMultipart(formData)
        case .editUserInfo(let userInfo):
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(userInfo)
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
            } catch {
                print("Error encoding userInfo: \(error)")
                return .requestPlain
            }
        case .editCategoryLike(let category):
            let params: [String: String] = [
                "categoryLike": category.categoryLike
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .fcmTokenUpdate(let fcmInfo):
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(fcmInfo)
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                return .requestParameters(parameters: dictionary, encoding: URLEncoding.queryString)
            } catch {
                print("Error encoding userInfo: \(error)")
                return .requestPlain
            }
        case .reissue:
            let params: [String: String] = [
                "accessToken": KeychainItem.currentAccessToken,
                "refreshToken": KeychainItem.currentRefreshToken
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .deleteOneHistory(let id):
            let params: [String: Any] = [
                "id": id
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .follow(let userId), .unfollow(let userId):
            let params: [String: Any] = [
                "userId": userId
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .report(let reason, let userId):
            let params: [String: Any] = [
                "reason": reason,
                "userId": userId
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .cancelReport(let userId):
            let params: [String: Any] = [
                "userId": userId
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .deleteSearchHistory, .reportList, .resign:
            return .requestPlain
        }
    }
    var headers: [String: String]? {
        let header = [
            "Content-type": "application/json",
        ]
        let accessToken = KeychainItem.currentAccessToken
        switch self {
        case .nicknameCheck, .reissue:
            return header
            
        case .editUserImage:
            var header = [
                "Content-Type": "multipart/form-data; boundary=<calculated when request is sent>"
            ]
            header["Authorization"] = accessToken
            return header
            
        default:
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
