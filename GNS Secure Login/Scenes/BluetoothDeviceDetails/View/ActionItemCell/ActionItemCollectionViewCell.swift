//
//  ActionItemCollectionViewCell.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 22/08/2021.
//

import UIKit

class ActionItemCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Identifer
    static let identifier = "ActionItemCollectionViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var actionTitleLabel: UILabel!
    
    // MARK: - Variables
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
