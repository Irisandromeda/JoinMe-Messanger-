//
//  UISegmentedControl + Extension.swift
//  Alien Messanger
//
//  Created by Irisandromeda on 04.09.2022.
//

import UIKit

extension UISegmentedControl {
    
    convenience init(first: String, second: String, tintColor: UIColor, selectedSegmentTintColor: UIColor) {
        self.init()
        
        self.insertSegment(withTitle: first, at: 0, animated: true)
        self.insertSegment(withTitle: second, at: 1, animated: true)
        self.tintColor = tintColor
        self.selectedSegmentTintColor = selectedSegmentTintColor
    }
    
}
