//
//  UsersViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 06.09.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

final class UsersViewController: UIViewController {
    
    var users = [MessangerUser]()
    private var usersListener: ListenerRegistration?
    
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MessangerUser>!
    
    let containerView = GradientView(from: .top, to: .bottom, startColor: #colorLiteral(red: 0.7098039216, green: 0.5058823529, blue: 0.9803921569, alpha: 1), endColor: #colorLiteral(red: 0.3294117647, green: 0.3568627451, blue: 0.9137254902, alpha: 1))
    
    enum Section: Int, CaseIterable {
        case users
    }
    
    private let currentUser: MessangerUser

    init(currentUser: MessangerUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        title = currentUser.email
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        usersListener?.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        setupCollectionView()
        createDataSource()
        
        usersListener = ListenerService.shared.usersOverWatch(users: users, completion: { result in
            switch result {
            case .success(let users):
                self.users = users
                self.reloadData(searchText: nil)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.reuseId)
        collectionView.register(UsersCell.self, forCellWithReuseIdentifier: UsersCell.reuseId)
        
        collectionView.delegate = self
    }
    
    private func reloadData(searchText: String?) {
        let filtered = users.filter { user in
            user.filtered(text: searchText)
        }
        
        var snapShot = NSDiffableDataSourceSnapshot<Section, MessangerUser>()
        snapShot.appendSections([.users])
        snapShot.appendItems(filtered, toSection: .users)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
}

    // MARK: Setup SearchBar

extension UsersViewController {
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
}

    // MARK: Data Source

extension UsersViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MessangerUser>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Error")
            }
            
            switch section {
            case .users:
                return self.configure(collectionView: collectionView, cellType: UsersCell.self, value: itemIdentifier, indexPath: indexPath)
            }
        }
    }
}

    // MARK: Setup Layout

extension UsersViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            
            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Error")
            }
            
            switch section {
            case .users:
                return self.createUser()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config
        
        return layout
    }
    
    private func createUser() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(150))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        let spacing = CGFloat(15)
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20)

        return section
    }
}

extension UsersViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let user = dataSource.itemIdentifier(for: indexPath) else { return }
        let userScreenFromUser = UserScreenFromUsersViewController(user: user)
        present(userScreenFromUser, animated: true)
    }
}

extension UsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(searchText: searchText)
    }
}
