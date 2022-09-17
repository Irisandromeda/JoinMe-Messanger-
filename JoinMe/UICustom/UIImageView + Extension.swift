//
//  UIImageView + Extension.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 04.09.2022.
//

import UIKit

extension UIImageView {
    
    convenience init(image: UIImage?, contentMode: ContentMode) {
        self.init()
        
        self.image = image
        self.contentMode = contentMode
    }
    
}
