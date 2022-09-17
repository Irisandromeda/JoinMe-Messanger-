//
//  UIStackView + Extensions.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 04.09.2022.
//

import UIKit

extension UIStackView {
    
    convenience init(arrangedSubViews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubViews)
        
        self.axis = axis
        self.spacing = spacing
    }
    
}
