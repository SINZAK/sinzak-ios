//
//  ProductsDetail.swift
//  Sinzak
//
//  Created by JongHoon on 2023/04/25.
//

import Foundation

struct ProductsDetail {
    let id: Int
    let userID: Int
    let author: String
    let authorPicture: String
    let univ: String?
    let certUni: Bool
    let certAuthor: Bool
    let followerNum: String
    let following: Bool
    let images: [String]?
    let title: String
    let category: String
    let date: String
    let content: String?
    let price: Int
    let topPrice: Int
    let suggest: Bool
    let like: Bool
    let likesCnt: Int
    let wish: Bool
    let views: Int
    let wishCnt: Int
    let chatCnt: Int
    let myPost: Bool
    let complete: Bool
    let width: Double
    let vertical: Double
    let height: Double
}
