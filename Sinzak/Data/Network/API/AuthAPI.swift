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
    
    // 대학 인증
    case univMailCertify(univName: String, univEmail: String)
    case univMailCodeCertify(code: Int, univName: String, univEmail: String)
    case univSchoolCardCertify1(univ: String)
    case univSchoolCardCertify2(id: Int, image: UIImage)
    
    // 액세스토큰, FCM 토큰
    case fcmTokenUpdate(fcmInfo: FCMTokenUpdate) // fcm 토큰 업데이트
    case reissue // 액세스 토큰 갱신
    // 검색기록 삭제
    case deleteSearchHistory // 검색기록 전체 삭제
    case deleteOneHistory(id: Int) // 검색기록 한 개 삭제

    // 신고
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
        case .fcmTokenUpdate:
            return "/users/fcm"
        case .reissue:
            return "/reissue"
        case .deleteSearchHistory:
            return "/users/deletehistories"
        case .deleteOneHistory:
            return "/users/history"
        case .cancelReport:
            return "/users/report/cancel"
        case .reportList:
            return "/users/reportlist"
        case .resign:
            return "/users/resign"
        case .univMailCertify:
            return "/certify/mail/send"
        case .univMailCodeCertify:
            return "/certify/mail/receive"
        case .univSchoolCardCertify1:
            return "/certify/univ"
        case let .univSchoolCardCertify2(id, _):
            return "/certify/\(id)/univ"
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
                return .requestParameters(parameters: dictionary, encoding: JSONEncoding.default)
            } catch {
                print("Error encoding userInfo: \(error)")
                return .requestPlain
            }
        
        case .fcmTokenUpdate(let fcmInfo):
            do {
                let encoder = JSONEncoder()
                let data = try encoder.encode(fcmInfo)
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] ?? [:]
                return .requestParameters(parameters: dictionary, encoding: JSONEncoding.default)
            } catch {
                print("Error encoding userInfo: \(error)")
                return .requestPlain
            }
        case .reissue:
            return .requestPlain
        case .deleteOneHistory(let id):
            let params: [String: Any] = [
                "id": id
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .cancelReport(let userId):
            let params: [String: Any] = [
                "userId": userId
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .deleteSearchHistory, .reportList, .resign:
            return .requestPlain
            
        case let .univMailCertify(univName, univEmail):
            let params: [String: Any] = [
                "univName": univName,
                "univ_email": univEmail
            ]
            return .requestParameters(
                parameters: params,
                encoding: JSONEncoding.default
            )
        case let .univMailCodeCertify(code, univName, univEmail):
            let params: [String: Any] = [
                "code": code,
                "univName": univName,
                "univ_email": univEmail
            ]
            return .requestParameters(
                parameters: params,
                encoding: JSONEncoding.default
            )
        case let .univSchoolCardCertify1(univ):
            let params: [String: Any] = [
                "univ": univ
            ]
            return .requestParameters(
                parameters: params,
                encoding: JSONEncoding.default
            )
        case let .univSchoolCardCertify2(_, image):
            var formData: [MultipartFormData] = []
            guard let imageData = image
                .jpegData(compressionQuality: 0.6) else {
                return .uploadMultipart(formData)
            }
            Log.debug(imageData)
            let imageName = String.uniqueFilename(withPrefix: "IMAGE")
            formData.append(
                MultipartFormData(
                    provider: .data(imageData),
                    name: "multipartFile",
                    fileName: "\(imageName).jpeg",
                    mimeType: "image/jpeg"
                ))
        
            return .uploadMultipart(formData)
            
//            let imageData = MultipartFormData(provider: .data(image.jpegData(compressionQuality: 1.0)!), name: "image", fileName: "jpeg", mimeType: "image/jpeg")
//                       return .uploadMultipart([imageData])
            
            
        }
    }
    var headers: [String: String]? {
        let header = [
            "Content-type": "application/json"
        ]
        let accessToken = KeychainItem.currentAccessToken
        
        switch self {
        case .nicknameCheck:
            return header
        
        default:
            if !accessToken.isEmpty {
                var header = header
                header["Authorization"] = accessToken
                return header
            } else {
                Log.error("액세스토큰이 없어 불가능합니다.")
                return header
            }
        }
    }
}
