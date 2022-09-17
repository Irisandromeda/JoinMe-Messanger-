//
//  UserInfoViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 09.09.2022.
//

import UIKit

class UserInfoViewController: UIViewController {
    
    let addPhotoDelegate = AddPhotoView()
    
    let titleLabel = UILabel(text: "Tell us about yourself", font: .avenir(size: 24), color: .black)
    let nameLabel = UILabel(text: "Name", font: .avenir(size: 17), color: .black)
    let aboutYouLabel = UILabel(text: "About you", font: .avenir(size: 17), color: .black)
    
    let nameTextField = OneTextField(textColor: .black, font: .avenir(size: 17))
    let aboutYouTextField = OneTextField(textColor: .black, font: .avenir(size: 17))
    
    let selectGender = UISegmentedControl(first: "Male", second: "Female", tintColor: .white, selectedSegmentTintColor: .systemPink)
    
    let saveButton = UIButton(title: "Save", titleColor: .white, backgroundColor: .systemPink, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSubViews()
    }
}

extension UserInfoViewController {
    
    private func setupSubViews() {
        view.backgroundColor = .mercury()
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
    }
    
    private func addConstraints() {
        let nameStackView = UIStackView(arrangedSubViews: [nameLabel,nameTextField], axis: .vertical, spacing: 10)
        let aboutYouStackView = UIStackView(arrangedSubViews: [aboutYouLabel,aboutYouTextField], axis: .vertical, spacing: 10)
        
        let centerStackView = UIStackView(arrangedSubViews: [nameStackView,aboutYouStackView,selectGender], axis: .vertical, spacing: 20)
        
        view.addSubview(titleLabel)
        view.addSubview(addPhotoDelegate)
        view.addSubview(centerStackView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 70),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            addPhotoDelegate.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            addPhotoDelegate.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
        
        NSLayoutConstraint.activate([
            centerStackView.topAnchor.constraint(equalTo: addPhotoDelegate.bottomAnchor, constant: 100),
            centerStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            centerStackView.widthAnchor.constraint(equalToConstant: 385)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: centerStackView.bottomAnchor, constant: 30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            saveButton.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
}

    // MARK: FOR CANVAS

import SwiftUI

struct UserInfoViewControllerPreview: UIViewControllerRepresentable {
    let viewControllerBuilder: () -> UIViewController

    init(_ viewControllerBuilder: @escaping () -> UIViewController) {
        self.viewControllerBuilder = viewControllerBuilder
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return viewControllerBuilder()
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

struct UserInfoViewController_Previews: PreviewProvider {
    static var previews: some View {
        ViewControllerPreview {
            UserInfoViewController()
        }
    }
}
