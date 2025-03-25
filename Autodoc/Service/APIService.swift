//
//  APIService.swift
//  Autodoc
//
//  Created by Konstantin Kotsarev on 24.03.2025.
//

import Foundation

final class APIService {
    private let basePath = "https://webapi.autodoc.ru/api"
    
    private lazy var session: URLSession = {
        return URLSession(configuration: .default)
    }()
    private lazy var decoder: JSONDecoder = {
        return JSONDecoder()
    }()
}

// MARK: - Methods

extension APIService {
    func fetchNews(page: Int, count: Int) async throws -> NewsResponse {
        let path = basePath + "/news" + "/\(page)" + "/\(count)"
        
        guard let url = URL(string: path) else {
            throw APIError.invalidUrlPath(path)
        }
        
        let (data, _) = try await session.data(from: url)
        return try decoder.decode(NewsResponse.self, from: data)
    }
}
