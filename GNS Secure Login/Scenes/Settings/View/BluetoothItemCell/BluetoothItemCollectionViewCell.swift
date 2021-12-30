//
//  BluetoothItemCollectionViewCell.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 09/08/2021.
//

import UIKit
import CoreBluetooth

final class BluetoothItemCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "BluetoothItemCollectionViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var bluetoothDeviceNameLabel: UILabel!
    @IBOutlet weak var bluetoothDeviceRSSILabel: UILabel!
    
    // MARK: - Variables
    var bleItem: CBPeripheral? {
        didSet { configure() }
    }
    var rssiValue: NSNumber? {
        didSet { configure() }
    }

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}

// MARK: - Helpers
extension BluetoothItemCollectionViewCell {
    
    private func configure() {
        guard let bleItem = bleItem,
        let rssiValue = rssiValue else { return }
        bluetoothDeviceNameLabel.text = bleItem.name ?? ""
        bluetoothDeviceRSSILabel.text = "\("rssi".localized()) \(rssiValue)"
    }
}
