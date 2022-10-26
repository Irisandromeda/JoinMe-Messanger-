//
//  ListViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 06.09.2022.
//

import UIKit
import FirebaseFirestore

class ListViewController: UIViewController {
    
    var activeChats = [MessangerChat]()
    var waitingChats = [MessangerChat]()
    
    private var waitingChatsListener: ListenerRegistration?
    private var activeChatsListener: ListenerRegistration?
    
    private let currentUser: MessangerUser
    
    init(currentUser: MessangerUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Section: Int, CaseIterable {
        case waitingChats, activeChats

        func setup() -> String {
            switch self {

            case .waitingChats:
                return ""
            case .activeChats:
                return "Already communicate:"
            }
        }
    }

    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, MessangerChat>?
    
    deinit {
        waitingChatsListener?.remove()
        activeChatsListener?.remove()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupCollectionView()
        createDataSource()
        setupSearchBar()
        reloadData()
        
        waitingChatsListener = ListenerService.shared.waitingChatsOverWatch(chats: waitingChats, completion: { result in
            switch result {
            case .success(let chats):
                self.waitingChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(title: "Something was wrong", message: error.localizedDescription)
            }
        })
        
        activeChatsListener = ListenerService.shared.activeChatsOverWatch(chats: activeChats, completion: { result in
            switch result {
            case .success(let chats):
                self.activeChats = chats
                self.reloadData()
            case .failure(let error):
                self.showAlert(title: "Something was wrong", message: error.localizedDescription)
            }
        })
    }

    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .mercury()
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)

        collectionView.register(Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Header.reuseId)
        collectionView.register(ActiveChatCell.self, forCellWithReuseIdentifier: ActiveChatCell.reuseId)
        collectionView.register(WaitingChatCell.self, forCellWithReuseIdentifier: WaitingChatCell.reuseId)
        
        collectionView.delegate = self
    }

}

    // MARK: Setup SearchBar

extension ListViewController {
    private func setupSearchBar() {
        navigationController?.navigationBar.barTintColor = .mercury()
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

extension ListViewController {
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, MessangerChat>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Error")
            }

            switch section {
            case .activeChats:
                return self.configure(collectionView: collectionView, cellType: ActiveChatCell.self, value: itemIdentifier, indexPath: indexPath)
            case .waitingChats:
                return self.configure(collectionView: collectionView, cellType: WaitingChatCell.self, value: itemIdentifier, indexPath: indexPath)
            }
        }

        dataSource?.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.reuseId, for: indexPath) as? Header else {
                fatalError("Header Error")
            }
            guard let section = Section(rawValue: indexPath.section) else {
                fatalError("Section Error")
            }

            header.configure(text: section.setup(), font: .avenir(size: 20), titleColor: .black)
            return header
        }
    }

    private func reloadData() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, MessangerChat>()
        snapShot.appendSections([.waitingChats, .activeChats])
        snapShot.appendItems(waitingChats, toSection: .waitingChats)
        snapShot.appendItems(activeChats, toSection: .activeChats)
        dataSource?.apply(snapShot, animatingDifferences: true)
    }
}

    // MARK: Setup Layout

extension ListViewController {
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in

            guard let section = Section(rawValue: sectionIndex) else {
                fatalError("Error")
            }

            switch section {

            case .activeChats:
                return self.createActiveChats()
            case .waitingChats:
                return self.createWaitingChats()
            }
        }

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20
        layout.configuration = config

        return layout
    }

    private func createWaitingChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(88), heightDimension: .absolute(88))

        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 10
        section.orthogonalScrollingBehavior = .groupPaging

        let header = createHeader()
        section.boundarySupplementaryItems = [header]

        return section
    }

    private func createActiveChats() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))

        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(78))

        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 20, bottom: 0, trailing: 20)
        section.interGroupSpacing = 10

        let header = createHeader()
        section.boundarySupplementaryItems = [header]

        return section
    }

    private func createHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(1))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)

        return header
    }
}

extension ListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let chat = dataSource?.itemIdentifier(for: indexPath) else { return }
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .waitingChats:
            let userScreenFromWaitingChats = UserScreenFromWaitingChatsViewController(chat: chat)
            userScreenFromWaitingChats.delegate = self
            present(userScreenFromWaitingChats, animated: true)
        case .activeChats:
            let chatViewController = ChatViewController(user: currentUser, chat: chat)
            chatViewController.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(chatViewController, animated: false)
        }
    }
}

extension ListViewController: ChatNavigation {
    func removeWaitingChat(chat: MessangerChat) {
        FireStoreService.shared.deleteWaitingChat(chat: chat) { result in
            switch result {
            case .success():
                self.showAlert(title: "Success", message: "Chat with \(chat.friendUsername) was deleted")
            case .failure(let error):
                self.showAlert(title: "Something was wrong", message: error.localizedDescription)
            }
        }
    }
    
    func addToActiveChat(chat: MessangerChat) {
        FireStoreService.shared.addToActive(chat: chat) { result in
            switch result {
            case .success():
                self.showAlert(title: "Success", message: "Chat with \(chat.friendUsername) added to active chats")
            case .failure(let error):
                self.showAlert(title: "Something was wrong", message: error.localizedDescription)
            }
        }
    }
    
    
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
