//
//  WaitingChatCell.swift
//  JoinMe
//
//  Created by Irisandromeda on 24.09.2022.
//

import UIKit
import SDWebImage

class WaitingChatCell: UICollectionViewCell, ConfigureCell {
    
    static var reuseId: String = "WaitingChatCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addConstraints()
        
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
    }
    
    func configure<A>(value: A) where A : Hashable {
        guard let chat = value as? MessangerChat else { return }
        imageView.sd_setImage(with: URL(string: chat.friendImageURL), completed: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

    // MARK: Setup Constraints

extension WaitingChatCell {
    private func addConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
