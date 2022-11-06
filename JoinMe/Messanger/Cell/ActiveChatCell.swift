//
//  ActiveChatCell.swift
//  JoinMe
//
//  Created by Irisandromeda on 23.09.2022.
//

import UIKit
import SDWebImage

final class ActiveChatCell: UICollectionViewCell, ConfigureCell  {
    
    static var reuseId: String = "ActiveChatCell"
    
    let imageView = UIImageView()
    let name = UILabel(text: "User name", font: .robotoMedium(size: 16), color: .black)
    let lastMessage = UILabel(text: "Hi, how are you?", font: .robotoRegular(size: 14), color: #colorLiteral(red: 0.4862745098, green: 0.4862745098, blue: 0.4862745098, alpha: 1))
    let messageIndicator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addConstraints()
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    func configure<A>(value: A) where A : Hashable {
        guard let chat = value as? MessangerChat else { return }
        imageView.sd_setImage(with: URL(string: chat.friendImageURL), completed: nil)
        name.text = chat.friendUsername
        lastMessage.text = chat.lastMessage
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

    // MARK: SetupConstraints

extension ActiveChatCell {
    private func addConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        lastMessage.translatesAutoresizingMaskIntoConstraints = false
        messageIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        addSubview(name)
        addSubview(lastMessage)
        addSubview(messageIndicator)
        
        imageView.backgroundColor = .black
        messageIndicator.backgroundColor = .systemPink
        
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 78),
            imageView.widthAnchor.constraint(equalToConstant: 78)
        ])
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: self.topAnchor, constant: -15),
            name.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 15),
            name.heightAnchor.constraint(equalToConstant: 78)
        ])
        
        NSLayoutConstraint.activate([
            lastMessage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 15),
            lastMessage.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 15),
            lastMessage.heightAnchor.constraint(equalToConstant: 78)
        ])
        
        NSLayoutConstraint.activate([
            messageIndicator.rightAnchor.constraint(equalTo: self.rightAnchor),
            messageIndicator.heightAnchor.constraint(equalToConstant: 78),
            messageIndicator.widthAnchor.constraint(equalToConstant: 10)
        ])
    }
}
