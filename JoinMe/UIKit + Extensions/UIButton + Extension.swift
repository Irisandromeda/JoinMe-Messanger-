//
//  UIButton + Extension.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 04.09.2022.
//

import UIKit

extension UIButton {
    
    convenience init(title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont?, isShadow: Bool, cornerRadius: CGFloat) {
        self.init(type: .system)
        
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.titleLabel?.font = font
        self.layer.cornerRadius = cornerRadius
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.cornerRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        } else {}
    }
    
    func buttonWithGoogleLogo() {
        let googleLogo = UIImageView(image: #imageLiteral(resourceName: "google"), contentMode: .scaleAspectFit)
        googleLogo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(googleLogo)
        googleLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        googleLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    func buttonWithAppleLogo() {
        let appleLogo = UIImageView(image: #imageLiteral(resourceName: "apple"), contentMode: .scaleAspectFit)
        appleLogo.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(appleLogo)
        appleLogo.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        appleLogo.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
}
