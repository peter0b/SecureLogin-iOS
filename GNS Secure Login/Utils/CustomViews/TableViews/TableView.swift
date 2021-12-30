//
//  TableView.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 23/07/2021.
//

import Foundation
import UIKit

class TableView<T: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    typealias RowConfigurator = (_ cell: T, _ row: Int) -> Void
    typealias RowSelector = (_ row: Int) -> Void
    
    private var itemsCount: Int
    private var rowConfigurator: RowConfigurator
    private var rowSelector: RowSelector
    private var rowHeight: CGFloat
    
    init(itemsCount: Int, rowConfigurator: @escaping RowConfigurator, rowSelector: @escaping RowSelector, rowHeight: CGFloat) {
        self.itemsCount = itemsCount
        self.rowConfigurator = rowConfigurator
        self.rowSelector = rowSelector
        self.rowHeight = rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(at: indexPath) as T
        rowConfigurator(cell, indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        rowSelector(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
}
