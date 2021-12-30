//
//  UITableViewExtensions.swift
//  Driver
//
//  Created by Peter Bassem on 26/12/2020.
//  Copyright © 2020 Eslam Maged. All rights reserved.
//

import UIKit

extension UITableView {
    
    static func cellIdentifier<Cell: UITableViewCell>(cell: Cell.Type) -> String {
        let nibName = String(describing: Cell.self)
        return nibName
    }
    
    static func headerdentifier<Cell: UITableViewHeaderFooterView>(cell: Cell.Type) -> String {
        let nibName = String(describing: Cell.self)
        return nibName
    }
    
    func registerCell<Cell: UITableViewCell>(cell: Cell.Type) {
        let nibName = String(describing: Cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
    
    func registerHeader<Header: UITableViewHeaderFooterView>(header: Header.Type) {
        let nibName = String(describing: Header.self)
        self.register(UINib(nibName: nibName, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: nibName)
    }
    
    func dequeueCell<Cell: UITableViewCell>(at indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Could not dequeue table view cell")
        }
        return cell
    }
    
    func dequeueHeader<Header: UITableViewHeaderFooterView>() -> Header {
        let identifier = String(describing: Header.self)
        guard let header = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? Header else {
            fatalError("Could not dequeue table view header")
        }
        return header
    }
}
