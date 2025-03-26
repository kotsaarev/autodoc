//
//  NewsViewController.swift
//  Autodoc
//
//  Created by Konstantin Kotsarev on 19.03.2025.
//

import UIKit
import Combine
import SafariServices

class NewsViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var viewModel = NewsViewModel()
    
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UICollectionViewDiffableDataSource<NewsSection, NewsModel.ID>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupDataSource()
        setupBindings()
        
        Task { try? await viewModel.loadMore() }
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ in
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(150)
                )
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .absolute(150)
                )
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 10
                
                return section
            }
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: NewsCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<NewsSection, NewsModel.ID>(collectionView: collectionView) {
            [weak self] (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell,
                  let newsItem = self?.viewModel.news.first(where: { $0.id == identifier }) else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: newsItem)
            
            return cell
        }
    }
    
    private func setupBindings() {
        viewModel.$news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] news in self?.applySnapshot(news) }
            .store(in: &cancellables)
    }
    
    private func applySnapshot(_ news: [NewsModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<NewsSection, NewsModel.ID>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(news.map({ $0.id }), toSection: .main)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UICollectionViewDelegate

extension NewsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let identifier = dataSource.itemIdentifier(for: indexPath),
              let newsItem = viewModel.news.first(where: { $0.id == identifier }),
              let url = URL(string: newsItem.fullUrl) else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}
