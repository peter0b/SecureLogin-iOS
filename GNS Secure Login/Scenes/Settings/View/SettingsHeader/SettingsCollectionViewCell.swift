//
//  SettingsCollectionViewCell.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 22/08/2021.
//

import UIKit

protocol SettingsCollectionViewCellDelegate: AnyObject {
    func SettingsCollectionViewCellBackButtonPressed()
    func SettingsCollectionViewCellRefreshBluetoothDevicesButtonPressed()
}

final class SettingsCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "SettingsCollectionViewCell"
    
    // MARK: - Outlets
    
    // MARK: - Variables
    weak var delegate: SettingsCollectionViewCellDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// MARK: - Selectors
extension SettingsCollectionViewCell {
    
    @IBAction
    private func backButtonDidPressed(_ sender: UIButton) {
        delegate?.SettingsCollectionViewCellBackButtonPressed()
    }
    
    @IBAction
    private func refreshBluetoothDevicesButtonDidPressed(_ sender: UIButton) {
        delegate?.SettingsCollectionViewCellRefreshBluetoothDevicesButtonPressed()
    }
}
