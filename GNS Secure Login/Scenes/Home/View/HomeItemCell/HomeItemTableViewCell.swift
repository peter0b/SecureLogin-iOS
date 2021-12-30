//
//  HomeItemTableViewCell.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 23/07/2021.
//

import UIKit

protocol HomeItemTableViewCellView {
    func displayTitle(_ title: String)
}

class HomeItemTableViewCell: BaseTableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Variaobles

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = .clear
        selectionStyle = .none
    }
}

extension HomeItemTableViewCell: HomeItemTableViewCellView {
    
    func displayTitle(_ title: String) {
        titleLabel.text = title
    }
}
