//
//  TabBarViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 06.09.2022.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController()
        let usersViewController = UsersViewController()
        let settingsViewController = SettingsViewController()
        
        let conversationImage = UIImage(systemName: "person.2.crop.square.stack")!
        let userImage = UIImage(systemName: "menucard")!
        let settingsImage = UIImage(systemName: "gearshape")!
        
        viewControllers = [
            generateNavigationControl(rootViewController: listViewController, title: "People", image: conversationImage),
            generateNavigationControl(rootViewController: usersViewController, title: "Conversations", image: userImage),
            generateNavigationControl(rootViewController: settingsViewController, title: "Settings", image: settingsImage)
        ]
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.tintColor = .systemPink
        tabBar.backgroundColor = .white
    }
    
    private func generateNavigationControl(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        return navigationVC
    }
    
}

    // MARK: FOR CANVAS

import SwiftUI

struct TabBarViewControllerPreview: UIViewControllerRepresentable {
    let viewControllerBuilder: () -> UIViewController

    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct TabBarViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            TabBarViewController()
        }
    }
}
