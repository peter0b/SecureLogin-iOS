//
//  ApplicationItemCollectionViewCell.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 02/08/2021.
//

import UIKit
import Kingfisher

protocol ApplicationItemCollectionViewCellDelegate: AnyObject {
    func didEditApplication(atIndex index: Int)
}

protocol ApplicationItemCollectionViewCellProtocol {
    func updateContainerViewLeadingConstraintForGrid()
    func updateContainerViewLeadingConstraintForNonGrid()
    
    func showApplicationNameLabel()
    func hideApplicationNameLabel()
    
    func showApplicaionImageView()
    func hideApplicaionImageView()
    
    func displayApplicationImage(_ image: UIImage)
    func displayApplicationImage(fromImageURL imageUrl: URL)
    func displayApplicationName(_ name: String)
}

final class ApplicationItemCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private weak var containerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var applicationImageView: UIImageView!
    @IBOutlet private weak var applicationNameLabel: UILabel!
    
    // MARK: - Variables
    var index: Int!
    weak var delegate: ApplicationItemCollectionViewCellDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// MARK: - Selectors
extension ApplicationItemCollectionViewCell {
    
    @IBAction
    private func editApplicationButtonDidPressed(_ sender: UIButton) {
        guard let index = index else { fatalError("MUST SELECT INDEX FIRST!!!") }
        delegate?.didEditApplication(atIndex: index)
    }
}

// MARK: - ApplicationItemCollectionViewCellProtocol
extension ApplicationItemCollectionViewCell: ApplicationItemCollectionViewCellProtocol {
    
    func updateContainerViewLeadingConstraintForGrid() {
        containerViewLeadingConstraint.constant = 10
    }
    
    func updateContainerViewLeadingConstraintForNonGrid() {
        containerViewLeadingConstraint.constant = 34
    }
    
    func showApplicationNameLabel() {
        applicationNameLabel.isHidden = false
    }
    
    func hideApplicationNameLabel() {
        applicationNameLabel.isHidden = true
    }
    
    func showApplicaionImageView() {
        applicationImageView.isHidden = false
    }
    
    func hideApplicaionImageView() {
        applicationImageView.isHidden = true
    }
    
    func displayApplicationImage(_ image: UIImage) {
        applicationImageView.image = image
    }
    
    func displayApplicationImage(fromImageURL imageUrl: URL) {
        applicationImageView.kf.setImage(with: imageUrl)
    }
    
    func displayApplicationName(_ name: String) {
        applicationNameLabel.text = name
    }
}
