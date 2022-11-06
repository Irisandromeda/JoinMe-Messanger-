//
//  UsersCell.swift
//  JoinMe
//
//  Created by Irisandromeda on 29.09.2022.
//

import UIKit
import SDWebImage

final class UsersCell: UICollectionViewCell, ConfigureCell {

    static var reuseId: String = "UsersCell"
    
    let containerView = UIView()
    let userImageView = UIImageView()
    let name = UILabel(text: "User name", font: .robotoRegular(size: 13), color: .black)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addConstraints()
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        containerView.backgroundColor = #colorLiteral(red: 0.9718816876, green: 0.9753244519, blue: 0.9844822288, alpha: 1)
        containerView.contentMode = .scaleAspectFill
    }
    
    func configure<A>(value: A) where A : Hashable {
        guard let user = value as? MessangerUser else { return }
        guard let url = URL(string: user.avatarURL) else { return }
        userImageView.sd_setImage(with: url, completed: nil)
        name.text = user.username
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension UsersCell {
    private func addConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        name.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(containerView)
        containerView.addSubview(userImageView)
        containerView.addSubview(name)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            userImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0),
            userImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            userImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        NSLayoutConstraint.activate([
            name.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            name.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            name.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }
}
