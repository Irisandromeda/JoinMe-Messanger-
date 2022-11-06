//
//  SingInViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 05.09.2022.
//

import UIKit

final class SingInViewController: UIViewController {
    
    let gradientView = GradientView(from: .top, to: .bottom, startColor: #colorLiteral(red: 0.7098039216, green: 0.5058823529, blue: 0.9803921569, alpha: 1), endColor: #colorLiteral(red: 0.3294117647, green: 0.3568627451, blue: 0.9137254902, alpha: 1))
    let containerView = UIView()
    
    let loginButton = UIButton(title: "Login", titleColor: #colorLiteral(red: 1, green: 0.9999999404, blue: 0.9999999404, alpha: 1) , backgroundColor: #colorLiteral(red: 0.3403419256, green: 0.2859731317, blue: 0.8841039538, alpha: 1) , font: .robotoMedium(size: 16), isShadow: true, cornerRadius: 10)
    let forgotPassword = UIButton(title: "Forgot your password?", titleColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) , backgroundColor: .clear, font: .robotoRegular(size: 14), isShadow: false, cornerRadius: 0)
    
    let emailLabel = UILabel(text: "Email", font: .robotoRegular(size: 14), color: #colorLiteral(red: 0.5593468547, green: 0.5593467951, blue: 0.5593468547, alpha: 1))
    let passwordLabel = UILabel(text: "Password", font: .robotoRegular(size: 14), color: #colorLiteral(red: 0.5593468547, green: 0.5593467951, blue: 0.5593468547, alpha: 1))
    
    let emailTextField = OneTextField(textColor: .black, font: .robotoRegular(size: 15))
    let passwordTextField = OneTextField(textColor: .black, font: .robotoRegular(size: 15))
    
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
        view.backgroundColor = .systemPink
        
        containerView.layer.cornerRadius = 30
        containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        passwordTextField.isSecureTextEntry = true
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        didButtonTap()
    }
    
    private func addConstraints() {
        let emailStackView = UIStackView(arrangedSubViews: [emailLabel,emailTextField], axis: .vertical, spacing: 25)
        let passwordStackView = UIStackView(arrangedSubViews: [passwordLabel,passwordTextField], axis: .vertical, spacing: 25)

        let centerStackView = UIStackView(arrangedSubViews: [emailStackView,passwordStackView], axis: .vertical, spacing: 16)
        let bottomStackView = UIStackView(arrangedSubViews: [loginButton,forgotPassword], axis: .vertical, spacing: 18)
        
        view.addSubview(gradientView)
        view.addSubview(containerView)
        
        view.addSubview(centerStackView)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 650)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 40),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            centerStackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 35),
            centerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            centerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            centerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: centerStackView.bottomAnchor, constant: 55),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            loginButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func didButtonTap() {
        loginButton.addTarget(self, action: #selector(loginButtonTap), for: .touchUpInside)
    }
    
    @objc private func loginButtonTap() {
        AuthService.service.login(email: emailTextField.text!, password: passwordTextField.text!) { result  in
            switch result {
                
            case .success(let user):
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
