//
//  UICollectionViewExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 26/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import UIKit

enum SupplementaryViewKind {
    case header
    case footer
    
    var description: String {
        switch self {
        case .header: return UICollectionView.elementKindSectionHeader
        case .footer: return UICollectionView.elementKindSectionFooter
        }
    }
}

extension UICollectionView {
    
    static func cellIdentifier<Cell: UICollectionViewCell>(cell: Cell.Type) -> String {
        let nibName = String(describing: Cell.self)
        return nibName
    }
    
    func registerCell<Cell: UICollectionViewCell>(cell: Cell.Type) {
        let nibName = String(describing: Cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
    
    func dequeueCell<Cell: UICollectionViewCell>(at indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue table view cell")
        }
        return cell
    }
    
    func registerHeader<Header: UICollectionViewCell>(header: Header.Type, type: SupplementaryViewKind) {
        let nibName = String(describing: Header.self)
        self.register(UINib(nibName: nibName, bundle: nil), forSupplementaryViewOfKind: type.description, withReuseIdentifier: nibName)
    }
    
    func dequeueHeader<Header: UICollectionViewCell>(for kind: String, at indexPath: IndexPath) -> Header {
        let nibName = String(describing: Header.self)
        guard let header = self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: nibName, for: indexPath) as? Header else {
            fatalError("Could not dequeue collection view header")
        }
        return header
    }
}
