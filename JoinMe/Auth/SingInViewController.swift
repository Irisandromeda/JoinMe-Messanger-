//
//  SingInViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 05.09.2022.
//

import UIKit

class SingInViewController: UIViewController {
    
    let appleButton = UIButton(title: "Apple", titleColor: .black, backgroundColor: .white, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    let googleButton = UIButton(title: "Goolge", titleColor: .black, backgroundColor: .white, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    let facebookButton = UIButton(title: "Facebook", titleColor: .black, backgroundColor: .white, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    let loginButton = UIButton(title: "Login", titleColor: .white, backgroundColor: .systemPink, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    let forgotPassword = UIButton(title: "Forgot your password?", titleColor: .systemPink, backgroundColor: .clear, font: .avenir(size: 15), isShadow: true, cornerRadius: 5)
    
    let emailLabel = UILabel(text: "Email", font: .avenir(size: 15), color: .gray)
    let passwordLabel = UILabel(text: "Password", font: .avenir(size: 15), color: .gray)
    
    let emailTextField = OneTextField(textColor: .black, font: .avenir(size: 15))
    let passwordTextField = OneTextField(textColor: .black, font: .avenir(size: 15))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSubViews()
    }
    
}

extension SingInViewController {
    
    private func setupSubViews() {
        view.backgroundColor = .mercury()
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        didButtonTap()
        appleButton.buttonWithAppleLogo()
        googleButton.buttonWithGoogleLogo()
        facebookButton.buttonWithFacebookLogo()
    }
    
    private func addConstraints() {
        let emailStackView = UIStackView(arrangedSubViews: [emailLabel,emailTextField], axis: .vertical, spacing: 10)
        let passwordStackView = UIStackView(arrangedSubViews: [passwordLabel,passwordTextField], axis: .vertical, spacing: 10)
        
        let topStackView = UIStackView(arrangedSubViews: [appleButton,googleButton,facebookButton], axis: .vertical, spacing: 20)
        let centerStackView = UIStackView(arrangedSubViews: [emailStackView,passwordStackView], axis: .vertical, spacing: 15)
        let bottomStackView = UIStackView(arrangedSubViews: [forgotPassword,loginButton], axis: .vertical, spacing: 15)
        
        view.addSubview(topStackView)
        view.addSubview(centerStackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            topStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            topStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            topStackView.widthAnchor.constraint(equalToConstant: 385)
        ])
        
        NSLayoutConstraint.activate([
            centerStackView.topAnchor.constraint(equalTo: topStackView.bottomAnchor, constant: 30),
            centerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            centerStackView.widthAnchor.constraint(equalToConstant: 385)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: centerStackView.bottomAnchor, constant: 30),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            bottomStackView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func didButtonTap() {
        loginButton.addTarget(self, action: #selector(loginButtonTap), for: .touchUpInside)
    }
    
    @objc func loginButtonTap() {
        AuthService.service.login(email: emailTextField.text!, password: passwordTextField.text!) { result  in
            switch result {
                
            case .success(let user):
//                self.showAlert(title: "Successfully", message: "Welcome!")
                FireStoreService.shared.getUserData(user: user) { result in
                    switch result {
                    case .success(let user):
                        let tabBarViewController = TabBarViewController(currentUser: user)
                        tabBarViewController.modalPresentationStyle = .fullScreen
                        self.present(tabBarViewController, animated: true)
                    case .failure(_):
                        let userInfoViewController = UserInfoViewController(currentUser: user)
                        userInfoViewController.modalPresentationStyle = .fullScreen
                        self.present(userInfoViewController, animated: true)
                    }
                }
                print(user.email!)
            case .failure(let error):
                self.showAlert(title: "Something was wrong!", message: "Try again! \(error.localizedDescription)")
            }
        }
    }
    
}

    // MARK: FOR CANVAS

import SwiftUI

struct SingInViewControllerPreview: UIViewControllerRepresentable {
    let viewControllerBuilder: () -> UIViewController

    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct SingInViewController_Previews: PreviewProvider {
    static var previews: some View {
        SingInViewControllerPreview {
            SingInViewController()
        }
    }
}
