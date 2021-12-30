//
//  CollectionView.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 22/07/2021.
//

import Foundation
import UIKit

class CollectionView<T: UICollectionViewCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    typealias ItemConfigurator = (_ cell: T, _ item: Int) -> Void
    typealias ItemSelector = (_ item: Int) -> Void
    
    private var itemsCount: Int
    private var itemConfigurator: ItemConfigurator
    private var itemSelector: ItemSelector
    private var itemSize: CGSize
    private var itemSpacing: CGFloat
    
    /// <#Description#>
    /// - Parameters:
    ///   - itemsCount: collection items count.
    ///   - itemConfigurator: cell configuration.
    ///   - itemSelector: cell selection.
    ///   - itemSize: cell item size.
    ///   - itemSpacing: spacing between cells.
    init(itemsCount: Int, itemConfigurator: @escaping ItemConfigurator, itemSelector: @escaping ItemSelector, itemSize: CGSize, itemSpacing: CGFloat = 0.0) {
        self.itemsCount = itemsCount
        self.itemConfigurator = itemConfigurator
        self.itemSelector = itemSelector
        self.itemSize = itemSize
        self.itemSpacing = itemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(at: indexPath) as T
        itemConfigurator(cell, indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        itemSelector(indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return itemSpacing
        }
}
