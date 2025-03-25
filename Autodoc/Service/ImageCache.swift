//
//  ImageCache.swift
//  Autodoc
//
//  Created by Konstantin Kotsarev on 25.03.2025.
//

import UIKit

final class ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    private lazy var session: URLSession = {
        return URLSession(configuration: .default)
    }()
}

// MARK: - Methods

extension ImageCache {
    func loadImage(url: URL) async -> UIImage? {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        do {
            let (data, _) = try await session.data(from: url)
            
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            cache.setObject(image, forKey: url as NSURL)
            
            return image
        } catch {
            return nil
        }
    }
}
