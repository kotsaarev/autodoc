//
//  NewsModel.swift
//  Autodoc
//
//  Created by Konstantin Kotsarev on 24.03.2025.
//

struct NewsModel: Decodable, Hashable {
    let id: Int
    let title: String
    let description: String
    let publishedDate: String
    let url: String
    let fullUrl: String
    let titleImageUrl: String
    let categoryType: String
}
