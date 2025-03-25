//
//  NewsViewModel.swift
//  Autodoc
//
//  Created by Konstantin Kotsarev on 24.03.2025.
//

import Foundation

final class NewsViewModel: ObservableObject {
    @Published private(set) var news: [NewsModel] = []
    
    private let service = APIService()
    private var currentPage = 1
    private var isLoading = false
}

// MARK: - Methods

extension NewsViewModel {
    func loadMore() async throws {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        
        let count = APIConstants.newsPerPage
        let response = try await service.fetchNews(page: currentPage, count: count)
        
        news.append(contentsOf: response.news)
        currentPage += 1
        
        isLoading = false
    }
}
