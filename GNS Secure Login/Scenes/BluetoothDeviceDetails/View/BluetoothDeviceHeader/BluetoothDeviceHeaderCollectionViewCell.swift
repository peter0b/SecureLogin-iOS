//
//  BluetoothDeviceHeaderCollectionViewCell.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 22/08/2021.
//

import UIKit

protocol BluetoothDeviceHeaderCollectionViewCellDelegate: AnyObject {
    func bluetoothDeviceHeaderCollectionViewCellBackButtonPressed()
    func connectReader()
    func disconnectReader()
    func connectBadge()
    func disconnectBadge()
}

final class BluetoothDeviceHeaderCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "BluetoothDeviceHeaderCollectionViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var bluetoothDeviceNameLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var isOnSwitch: UISwitch!
    
    // MARK: - Variables
    weak var delegate: BluetoothDeviceHeaderCollectionViewCellDelegate?
    var bluetoothType: BluetoothType!

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// MARK: - Selectors
extension BluetoothDeviceHeaderCollectionViewCell {
    
    @IBAction
    private func backButtonDidPressed(_ sender: UIButton) {
        delegate?.bluetoothDeviceHeaderCollectionViewCellBackButtonPressed()
    }
    
    @IBAction
    private func bluetoothIsOnSwitch(_ sender: UISwitch) {
        switch bluetoothType {
        case .badges:
            sender.isOn ? delegate?.connectBadge() : delegate?.disconnectBadge()
        case .readers:
            sender.isOn ? delegate?.connectReader() : delegate?.disconnectReader()
        case .none: break
        }
    }
}
