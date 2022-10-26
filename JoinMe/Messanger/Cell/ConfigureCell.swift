//
//  ConfigureCell.swift
//  JoinMe
//
//  Created by Irisandromeda on 24.09.2022.
//

import UIKit

protocol ConfigureCell {
    static var reuseId: String { get }
    func configure<A: Hashable>(value: A)
}
