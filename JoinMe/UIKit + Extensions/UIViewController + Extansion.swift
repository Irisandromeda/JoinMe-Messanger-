//
//  UIViewController + Extansion.swift
//  JoinMe
//
//  Created by Irisandromeda on 29.09.2022.
//

import UIKit

extension UIViewController {
    func configure<T: ConfigureCell, A: Hashable>(collectionView: UICollectionView, cellType: T.Type, value: A, indexPath: IndexPath) -> T {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.reuseId, for: indexPath) as? T else {
            fatalError("Failed dequeue")
        }
        
        cell.configure(value: value)
        return cell
    }
}
