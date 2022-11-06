//
//  TabBarViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 06.09.2022.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    private let currentUser: MessangerUser

    init(currentUser: MessangerUser) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController(currentUser: currentUser)
        let usersViewController = UsersViewController(currentUser: currentUser)
        let settingsViewController = SettingsViewController()
        
        let conversationImage = UIImage(systemName: "menucard")!
        let userImage = UIImage(systemName: "person.2.crop.square.stack")!
        let settingsImage = UIImage(systemName: "gearshape")!
        
        viewControllers = [
            generateNavigationControl(rootViewController: usersViewController, title: "People", image: userImage),
            generateNavigationControl(rootViewController: listViewController, title: "Conversations", image: conversationImage),
            generateNavigationControl(rootViewController: settingsViewController, title: "Settings", image: settingsImage)
        ]
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.backgroundColor = .white
        tabBar.tintColor = #colorLiteral(red: 0.2666666667, green: 0.1725490196, blue: 0.8549019608, alpha: 1)
        tabBar.unselectedItemTintColor = .gray
    }
    
    private func generateNavigationControl(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
}
