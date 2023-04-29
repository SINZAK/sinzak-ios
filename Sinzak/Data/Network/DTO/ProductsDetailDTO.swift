//
//  ProductsDetailDTO.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/25.
//

import Foundation

struct ProductsDetailDTO: Codable {
    let id: Int?
    let userID: Int?
    let author: String?
    let authorPicture: String?
    let univ: String?
    let certUni: Bool?
    let certAuthor: Bool?
    let followerNum: String?
    let following: Bool?
    let images: [String]?
    let title: String?
    let category: String?
    let date: String?
    let content: String?
    let price: Int?
    let topPrice: Int?
    let suggest: Bool?
    let like: Bool?
    let likesCnt: Int?
    let wish: Bool?
    let views: Int?
    let wishCnt: Int?
    let chatCnt: Int?
    let myPost: Bool?
    let complete: Bool?
    let width: Double?
    let vertical: Double?
    let height: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "uerId"
        case author
        case authorPicture = "author_picture"
        case univ
        case certUni = "cert_uni"
        case certAuthor = "cert_author"
        case followerNum
        case following
        case images
        case title
        case category
        case date
        case content
        case price
        case topPrice
        case suggest
        case like
        case likesCnt
        case wish
        case views
        case wishCnt
        case chatCnt
        case myPost
        case complete
        case width
        case vertical
        case height
    }
    
    func toDomain() -> ProductsDetail {
        return ProductsDetail(
            id: id ?? -1,
            userID: userID ?? -1,
            author: author ?? "",
            authorPicture: authorPicture ?? "",
            univ: univ,
            certUni: certUni ?? false,
            certAuthor: certAuthor ?? false,
            followerNum: followerNum ?? "",
            following: following ?? false,
            images: images,
            title: title ?? "",
            category: category ?? "",
            date: date ?? "",
            content: content,
            price: price ?? -1,
            topPrice: topPrice ?? -1,
            suggest: suggest ?? false,
            like: like ?? false,
            likesCnt: likesCnt ?? -1,
            wish: wish ?? false,
            views: views ?? -1,
            wishCnt: wishCnt ?? -1,
            chatCnt: chatCnt ?? -1,
            myPost: myPost ?? false,
            complete: complete ?? false,
            width: width ?? 0,
            vertical: vertical ?? 0,
            height: height ?? 0
        )
    }
}
