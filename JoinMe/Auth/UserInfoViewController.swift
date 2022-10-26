//
//  UserInfoViewController.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 09.09.2022.
//

import UIKit
import FirebaseAuth

class UserInfoViewController: UIViewController {
    
    let addPhotoDelegate = AddPhotoView()
    
    let titleLabel = UILabel(text: "Tell us about yourself", font: .avenir(size: 24), color: .black)
    let nameLabel = UILabel(text: "Name", font: .avenir(size: 17), color: .black)
    let aboutMeLabel = UILabel(text: "About you", font: .avenir(size: 17), color: .black)
    
    let nameTextField = OneTextField(textColor: .black, font: .avenir(size: 17))
    let aboutYouTextField = OneTextField(textColor: .black, font: .avenir(size: 17))
    
    let selectGender = UISegmentedControl(first: "Male", second: "Female", tintColor: .white, selectedSegmentTintColor: .systemPink)
    
    let saveButton = UIButton(title: "Save", titleColor: .white, backgroundColor: .systemPink, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    
    let currentUser: User

    init(currentUser: User) {
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addConstraints()
        didButtonTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSubViews()
    }
    
    func didButtonTap() {
        saveButton.addTarget(self, action: #selector(saveButtonTap), for: .touchUpInside)
        addPhotoDelegate.setImageButton.addTarget(self, action: #selector(setImageButtonTap), for: .touchUpInside)
    }
    
    @objc private func setImageButtonTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

    @objc private func saveButtonTap() {
        FireStoreService.shared.saveUserInfo(id: currentUser.uid,
                                             email: currentUser.email!,
                                             userImage: addPhotoDelegate.imageView.image,
                                             username: nameTextField.text!,
                                             description: aboutYouTextField.text!,
                                             gender: selectGender.titleForSegment(at: selectGender.selectedSegmentIndex)) { result in
            switch result {
            case .success(let messangerUser):
                let tabBar = TabBarViewController(currentUser: messangerUser)
                tabBar.modalPresentationStyle = .fullScreen
                self.present(tabBar, animated: true)
                self.showAlert(title: "Completed", message: "")
                print(messangerUser.email)
            case .failure(let error):
                self.showAlert(title: "Error", message: error.localizedDescription)
            }
        }
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
        let aboutYouStackView = UIStackView(arrangedSubViews: [aboutMeLabel,aboutYouTextField], axis: .vertical, spacing: 10)
        
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

extension UserInfoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        addPhotoDelegate.imageView.image = image
    }
}
