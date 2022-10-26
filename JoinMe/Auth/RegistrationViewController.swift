//
//  RegistrationViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 05.09.2022.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    let appleButton = UIButton(title: "Apple", titleColor: .black, backgroundColor: .white, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    let googleButton = UIButton(title: "Goolge", titleColor: .black, backgroundColor: .white, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    let facebookButton = UIButton(title: "Facebook", titleColor: .black, backgroundColor: .white, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    let createButton = UIButton(title: "Create an account", titleColor: .white, backgroundColor: .systemPink, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    
    let emailLabel = UILabel(text: "Email", font: .avenir(size: 15), color: .gray)
    let passwordLabel = UILabel(text: "Password", font: .avenir(size: 15), color: .gray)
    let confirmPasswordLabel = UILabel(text: "Confrim the password", font: .avenir(size: 15), color: .gray)
    
    let emailTextField = OneTextField(textColor: .black, font: .avenir(size: 15))
    let passwordTextField = OneTextField(textColor: .black, font: .avenir(size: 15))
    let confirmPasswordTextField = OneTextField(textColor: .black, font: .avenir(size: 15))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSubViews()
    }
    
}

extension RegistrationViewController {
    
    private func setupSubViews() {
        view.backgroundColor = .mercury()
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        appleButton.buttonWithAppleLogo()
        googleButton.buttonWithGoogleLogo()
        facebookButton.buttonWithFacebookLogo()
        didButtonTap()
    }
    
    private func addConstraints() {
        let emailStackView = UIStackView(arrangedSubViews: [emailLabel,emailTextField], axis: .vertical, spacing: 10)
        let passwordStackView = UIStackView(arrangedSubViews: [passwordLabel,passwordTextField], axis: .vertical, spacing: 10)
        let confirmPasswordStackView = UIStackView(arrangedSubViews: [confirmPasswordLabel,confirmPasswordTextField], axis: .vertical, spacing: 10)
        
        let topStackView = UIStackView(arrangedSubViews: [appleButton,googleButton,facebookButton], axis: .vertical, spacing: 20)
        let centerStackView = UIStackView(arrangedSubViews: [emailStackView,passwordStackView,confirmPasswordStackView], axis: .vertical, spacing: 15)
        
        view.addSubview(topStackView)
        view.addSubview(centerStackView)
        view.addSubview(createButton)
        
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
            createButton.topAnchor.constraint(equalTo: centerStackView.bottomAnchor, constant: 30),
            createButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            createButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func didButtonTap() {
        createButton.addTarget(self, action: #selector(createButtonTap), for: .touchUpInside)
    }
    
    @objc private func createButtonTap() {
        AuthService.service.register(email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text) { result in
            switch result {
                
            case .success(let user):
                AuthService.service.confirmEmail()
                self.present(UserInfoViewController(currentUser: user), animated: true)
                self.showAlert(title: "Successfully", message: "Welcome!")
                print(user.email!)
            case .failure(let error):
                self.showAlert(title: "Something was wrong", message: "Try again! \(error.localizedDescription)")
            }
        }
    }
    
}

    // MARK: FOR CANVAS

import SwiftUI

struct RegistrationViewControllerPreview: UIViewControllerRepresentable {
    let viewControllerBuilder: () -> UIViewController

    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct RegistrationViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            RegistrationViewController()
        }
    }
}
