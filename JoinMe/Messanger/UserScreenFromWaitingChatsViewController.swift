//
//  UserScreenFromWaitingChatsViewController.swift
//  JoinMe
//
//  Created by Irisandromeda on 03.10.2022.
//

import UIKit

class UserScreenFromWaitingChatsViewController: UIViewController {
    
    let containerView = UIView()
    let userImage = UIImageView(image: #imageLiteral(resourceName: "testPhoto2"), contentMode: .scaleAspectFill)
    let username = UILabel(text: "Name", font: .avenir(size: 22), color: .black)
    let aboutMe = UILabel(text: "About Me", font: .avenir(size: 18), color: .black)
    let acceptButton = UIButton(title: "Accept", titleColor: .white, backgroundColor: .green, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    let cancelButton = UIButton(title: "Cancel", titleColor: .white, backgroundColor: .systemPink, font: .avenir(size: 17), isShadow: true, cornerRadius: 5)
    
    weak var delegate: ChatNavigation?
    
    private var chat: MessangerChat
    
    init(chat: MessangerChat) {
        self.chat = chat
        self.userImage.sd_setImage(with: URL(string: chat.friendImageURL), completed: nil)
        self.username.text = chat.friendUsername
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
        acceptButton.addTarget(self, action: #selector(acceptButtonTap), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonTap), for: .touchUpInside)
    }
    
    @objc private func acceptButtonTap() {
        self.dismiss(animated: true) {
            self.delegate?.addToActiveChat(chat: self.chat)
        }
    }
    
    @objc private func cancelButtonTap() {
        self.dismiss(animated: true) {
            self.delegate?.removeWaitingChat(chat: self.chat)
        }
    }
}

extension UserScreenFromWaitingChatsViewController {
    
    private func setupSubViews() {
        containerView.backgroundColor = .mercury()
        containerView.layer.cornerRadius = 40

        view.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func addConstraints() {
        let buttonStackView = UIStackView(arrangedSubViews: [acceptButton,cancelButton], axis: .horizontal, spacing: 20)
        
        username.translatesAutoresizingMaskIntoConstraints = false
        aboutMe.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(userImage)
        view.addSubview(containerView)
        containerView.addSubview(username)
        containerView.addSubview(aboutMe)
        containerView.addSubview(buttonStackView)
        
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
            buttonStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -60),
            buttonStackView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            acceptButton.widthAnchor.constraint(equalToConstant: 150),
            cancelButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
}
