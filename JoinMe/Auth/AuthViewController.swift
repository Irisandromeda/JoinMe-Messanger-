//
//  AuthViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 04.09.2022.
//

import UIKit

class AuthViewController: UIViewController {
    
    let backgroundImage = UIImageView(image: #imageLiteral(resourceName: "background"), contentMode: .scaleAspectFill)
    let backgroundSliceOne = UIImageView(image: #imageLiteral(resourceName: "background_slice1"), contentMode: .center)
    let backgroundSliceTwo = UIImageView(image: #imageLiteral(resourceName: "background_slice2"), contentMode: .center)
    
    let createAccountButton = UIButton(title: "GET STARTED", titleColor: .blue, backgroundColor: .white, font: .roboto(size: 17), isShadow: false, cornerRadius: 10)
    let singInButton = UIButton(title: "SIGN IN", titleColor: .white, backgroundColor: .clear, font: .roboto(size: 17), isShadow: false, cornerRadius: 5)

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
        
        
        view.addSubview(backgroundImage)
        view.addSubview(backgroundSliceOne)
        view.addSubview(backgroundSliceTwo)
        view.addSubview(bottomStackView)
        
        NSLayoutConstraint.activate([
            bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -121),
            bottomStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            bottomStackView.widthAnchor.constraint(equalToConstant: 320),
            bottomStackView.heightAnchor.constraint(equalToConstant: 86),
            createAccountButton.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0)
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

    // MARK: FOR CANVAS

import SwiftUI

struct ViewControllerPreview: UIViewControllerRepresentable {
    let viewControllerBuilder: () -> UIViewController

    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct FirstViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            AuthViewController()
        }
    }
}

