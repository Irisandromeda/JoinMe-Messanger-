//
//  SettingsViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 06.09.2022.
//

import UIKit
import FirebaseAuth

final class SettingsViewController: UIViewController {
    
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(signOutButtonTap))
        
        setupSearchBar()
    }
    
    @objc private func signOutButtonTap() {
            let alert = UIAlertController(title: nil, message: "You want to sign out?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
                do {
                    try Auth.auth().signOut()
                    UIApplication.shared.keyWindow?.rootViewController = AuthViewController()
                } catch {
                    print("Error signing out: \(error.localizedDescription)")
                }
            }))
            present(alert, animated: true, completion: nil)
    }
}

    // MARK: Setup SearchBar

extension SettingsViewController {
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

extension SettingsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

extension SettingsViewController {
    
    private func setupSubViews() {
        view.backgroundColor = .mercury()
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}
