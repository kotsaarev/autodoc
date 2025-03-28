//
//  NewsCell.swift
//  Autodoc
//
//  Created by Konstantin Kotsarev on 25.03.2025.
//

import UIKit

final class NewsCell: UICollectionViewCell {
    static let identifier = "NewsCell"
    
    private var imageUrl: String?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        return UILabel()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.6),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Methods

extension NewsCell {
    func configure(news: NewsModel, imageCache: ImageCache) {
        imageUrl = news.titleImageUrl
        
        imageView.image = nil
        titleLabel.text = news.title
        
        Task {
            if let imageUrl = news.titleImageUrl,
               let url = URL(string: imageUrl),
               let image = await imageCache.loadImage(url: url) {
                DispatchQueue.main.async { [weak self] in
                    guard self?.imageUrl == news.titleImageUrl else {
                        return
                    }
                    
                    self?.imageView.image = image
                }
            }
        }
    }
}
