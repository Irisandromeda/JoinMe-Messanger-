//
//  AuthViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 04.09.2022.
//

import UIKit

final class AuthViewController: UIViewController {
    
    let gradientView = GradientView(from: .top, to: .bottom, startColor: #colorLiteral(red: 0.7098039216, green: 0.5058823529, blue: 0.9803921569, alpha: 1), endColor: #colorLiteral(red: 0.3294117647, green: 0.3568627451, blue: 0.9137254902, alpha: 1))
    let backgroundSliceOne = UIImageView(image: #imageLiteral(resourceName: "background_slice1"), contentMode: .center)
    let backgroundSliceTwo = UIImageView(image: #imageLiteral(resourceName: "background_slice2"), contentMode: .center)
    
    let createAccountButton = UIButton(title: "GET STARTED", titleColor: #colorLiteral(red: 0.3403419256, green: 0.2859731317, blue: 0.8841039538, alpha: 1), backgroundColor: .white, font: .robotoBold(size: 16), isShadow: false, cornerRadius: 10)
    let singInButton = UIButton(title: "SIGN IN", titleColor: #colorLiteral(red: 0.9718816876, green: 0.9753244519, blue: 0.9844822288, alpha: 1), backgroundColor: .clear, font: .robotoBold(size: 16), isShadow: false, cornerRadius: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSubViews()
    }

}

extension AuthViewController {
    
    private func setupSubViews() {
        view.backgroundColor = .black
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        didButtonTap()
    }
    
    private func addConstraints() {
        let bottomStackView = UIStackView(arrangedSubViews: [createAccountButton,singInButton], axis: .vertical, spacing: 22)
        
        
        view.addSubview(gradientView)
        view.addSubview(backgroundSliceOne)
        view.addSubview(backgroundSliceTwo)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -121),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            createAccountButton.heightAnchor.constraint(equalToConstant: 48),
            bottomStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            bottomStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            gradientView.topAnchor.constraint(equalTo: view.topAnchor),
            gradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backgroundSliceOne.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundSliceOne.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            backgroundSliceTwo.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundSliceTwo.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
    }
    
    private func didButtonTap() {
        createAccountButton.addTarget(self, action: #selector(createAccountTap), for: .touchUpInside)
        singInButton.addTarget(self, action: #selector(singInTap), for: .touchUpInside)
    }
    
    @objc private func createAccountTap() {
        let viewController = RegistrationViewController()
        viewController.modalTransitionStyle = .flipHorizontal
        present(viewController, animated: true)
    }
    
    @objc private func singInTap() {
        let viewController = SingInViewController()
        viewController.modalTransitionStyle = .flipHorizontal
        present(viewController, animated: true)
    }
    
}

