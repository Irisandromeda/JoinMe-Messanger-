//
//  SceneDelegate.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 04.09.2022.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.backgroundColor = .black
        
         //MARK:  USER? Login check
        
        if let user = Auth.auth().currentUser {
            FireStoreService.shared.getUserData(user: user) { result in
                switch result {
                case .success(let user):
                    let tabBarViewController = TabBarViewController(currentUser: user)
                    tabBarViewController.modalPresentationStyle = .fullScreen
                    self.window?.rootViewController = tabBarViewController
                case .failure(_):
                    self.window?.rootViewController = AuthViewController()
                }
            }
        } else {
            self.window?.rootViewController = AuthViewController()
        }
        window?.makeKeyAndVisible()
    }
    
}

