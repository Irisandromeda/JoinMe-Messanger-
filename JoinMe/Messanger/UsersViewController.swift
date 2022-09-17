//
//  UsersViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 06.09.2022.
//

import UIKit

class UsersViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
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
    
}

extension UsersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
