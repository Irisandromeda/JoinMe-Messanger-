//
//  Header.swift
//  JoinMe
//
//  Created by Irisandromeda on 25.09.2022.
//

import UIKit

class Header: UICollectionReusableView {
    
    static let reuseId: String = "Header"
    
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
       addConstraints()
    }
    
    func configure(text: String, font: UIFont?, titleColor: UIColor) {
        label.text = text
        label.font = font
        label.tintColor = titleColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension Header {
    private func addConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(label)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
