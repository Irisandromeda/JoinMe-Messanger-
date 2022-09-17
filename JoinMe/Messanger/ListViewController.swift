//
//  ListViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 06.09.2022.
//

import UIKit

struct Chat: Hashable {
    var userName: String
    var userImage: UIImage
    var lastMessage: String
    var id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Chat, rhs: Chat) -> Bool {
        return lhs.id == rhs.id
    }
}

class ListViewController: UIViewController {
    
    let activeChats: [Chat] = [
        Chat(userName: "John", userImage: UIImage(named: "human_1")!, lastMessage: "How are you?"),
        Chat(userName: "Marry", userImage: UIImage(named: "human_2")!, lastMessage: "How are you?"),
        Chat(userName: "Roman", userImage: UIImage(named: "human_3")!, lastMessage: "How are you?"),
        Chat(userName: "Kenny", userImage: UIImage(named: "human_4")!, lastMessage: "How are you?")
    ]
    
    enum Section: Int, CaseIterable {
        case activeChats
    }
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Chat>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupCollectionView()
        createDataSource()
        reloadData()
        setupSearchBar()
    }
    
    private func setupSearchBar() {
        let searchBar = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchBar
        navigationController?.navigationItem.backBarButtonItem?.tintColor = .systemPink
        navigationItem.hidesBackButton = false
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Chat>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Error")
            }
            
            switch section {
            case .activeChats:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                cell.backgroundColor = .systemPink
                return cell
            }
        }
    }
    
    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, Chat>()
        snapShot.appendSections([.activeChats])
        snapShot.appendItems(activeChats, toSection: .activeChats)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(90))
            
            let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20)
            
            return section
        }
        return layout
    }
    
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
