//
//  ApplicationsListHeaderCollectionViewCell.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 02/08/2021.
//

import UIKit

protocol ApplicationsListHeaderCollectionViewCellDelegate: AnyObject {
    func applicationsListHeaderCollectionViewCellBackButtonPressed()
    func applicationsListHeaderCollectionViewCellSearchButtonPressed()
    func applicationsListHeaderCollectionViewCellSortButtonPressed()
}

final class ApplicationsListHeaderCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Outlets
    
    // MARK: - Variables
    weak var delegate: ApplicationsListHeaderCollectionViewCellDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// MARK: - Selectors
extension ApplicationsListHeaderCollectionViewCell {
    
    @IBAction
    private func backButtonDidPressed(_ sender: UIButton) {
        delegate?.applicationsListHeaderCollectionViewCellBackButtonPressed()
    }
    
    @IBAction
    private func searchButtonDidPressed(_ sender: UIButton) {
        delegate?.applicationsListHeaderCollectionViewCellSearchButtonPressed()
    }
    
    @IBAction
    private func sortButtonDidPressed(_ sender: UIButton) {
        delegate?.applicationsListHeaderCollectionViewCellSortButtonPressed()
    }
}
