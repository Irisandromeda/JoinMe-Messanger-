//
//  UILabel + Extension.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 04.09.2022.
//

import UIKit

extension UILabel {
    
    convenience init(text: String, font: UIFont?, color: UIColor) {
        self.init()
        
        self.text = text
        self.font = font
        self.textColor = color
    }
    
}
