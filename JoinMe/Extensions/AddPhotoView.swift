//
//  AddPhotoView.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 04.09.2022.
//

import UIKit

class AddPhotoView: UIView {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = #imageLiteral(resourceName: "user_image")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0
        imageView.layer.borderColor = UIColor.black.cgColor
        
        return imageView
    }()
    
    let setImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        let image = #imageLiteral(resourceName: "button_plus")
        button.setImage(image, for: .normal)
        button.tintColor = .systemPink
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(setImageButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            setImageButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 15),
            setImageButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            setImageButton.widthAnchor.constraint(equalToConstant: 30),
            setImageButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        self.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: setImageButton.trailingAnchor).isActive = true
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
