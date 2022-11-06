//
//  UserScreenFromUsersViewController.swift
//  JoinMe
//
//  Created by Irisandromeda on 02.10.2022.
//

import UIKit
import SDWebImage

final class UserScreenFromUsersViewController: UIViewController {
    
    let containerView = UIView()
    let userImage = UIImageView(image: #imageLiteral(resourceName: "user_image"), contentMode: .scaleAspectFill)
    let username = UILabel(text: "Name", font: .robotoMedium(size: 22), color: .black)
    let aboutMe = UILabel(text: "About Me", font: .robotoRegular(size: 18), color: .black)
    let textField = OneTextField(textColor: .black, font: .robotoMedium(size: 18))
    let sendButton = UIButton(title: "Send a Message", titleColor: .white, backgroundColor: .systemPink, font: .robotoMedium(size: 16), isShadow: true, cornerRadius: 5)
    
    let user: MessangerUser
    
    init(user: MessangerUser) {
        self.user = user
        self.userImage.sd_setImage(with: URL(string: user.avatarURL), completed: nil)
        self.username.text = user.username
        self.aboutMe.text = user.description
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addConstraints()
        didButtonTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupSubViews()
    }
    
    func didButtonTap() {
        sendButton.addTarget(self, action: #selector(sendButtonTap), for: .touchUpInside)
    }
    
    @objc private func sendButtonTap() {
        guard let message = textField.text, message != "" else { return }
        
        self.dismiss(animated: true) {
            FireStoreService.shared.createWaitingChats(message: message, sender: self.user) { result in
                switch result {
                case .success():
                    self.showAlert(title: "Success", message: "Sended")
                case .failure(_):
                    self.showAlert(title: "Error", message: "error")
                }
            }
        }
    }
    
}

extension UserScreenFromUsersViewController {
    
    private func setupSubViews() {
        containerView.backgroundColor = .mercury()
        containerView.layer.cornerRadius = 40
        
        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func addConstraints() {
        username.translatesAutoresizingMaskIntoConstraints = false
        aboutMe.translatesAutoresizingMaskIntoConstraints = false
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userImage)
        view.addSubview(containerView)
        containerView.addSubview(username)
        containerView.addSubview(aboutMe)
        containerView.addSubview(textField)
        containerView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            userImage.topAnchor.constraint(equalTo: view.topAnchor),
            userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userImage.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 40)
        ])
        
        NSLayoutConstraint.activate([
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 220)
        ])
        
        NSLayoutConstraint.activate([
            username.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            username.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
            username.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            aboutMe.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 45),
            aboutMe.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
            aboutMe.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 90),
            textField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            sendButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            sendButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor, constant: 0),
            sendButton.widthAnchor.constraint(equalToConstant: 300)
        ])
    }
    
}
