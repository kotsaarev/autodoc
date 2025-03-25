//
//  NewsResponse.swift
//  Autodoc
//
//  Created by Konstantin Kotsarev on 24.03.2025.
//

struct NewsResponse: Decodable {
    let news: [NewsModel]
    let totalCount: Int
}
