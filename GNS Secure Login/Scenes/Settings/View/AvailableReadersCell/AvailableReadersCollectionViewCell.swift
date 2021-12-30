//
//  AvailableReadersCollectionViewCell.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 08/08/2021.
//

import UIKit
import CoreBluetooth

protocol AvailableReadersCollectionViewCellDelegate: AnyObject {
    func availableReadersCellDidSelectReader(withReader reader: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType)
}

final class AvailableReadersCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Identifiers
    static let identifier = "AvailableReadersCollectionViewCell"
    
    // MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    
    // MARK: - Variables
    var readers: [CBPeripheral]? {
        didSet { configure() }
    }
    var readersRSSI: [NSNumber]? {
        didSet { configure() }
    }
    
    var titleLabelHeight: CGFloat {
        return titleLabel.frame.size.height
    }
    
    private lazy var readersCollectionViewController: ReadersCollectionViewController = {
        let collectionViewController = ReadersCollectionViewController()
        collectionViewController.delegate = self
        return collectionViewController
    }()
    
    weak var viewControllerReference: SettingsViewController?
    private var collectionViewControllerHeight: CGFloat? {
        didSet {
            viewControllerReference?.isNFCCardRefreshed = false
            viewControllerReference?.nfcsHeight = collectionViewControllerHeight ?? 0.0
        }
    }
    
    weak var delegate: AvailableReadersCollectionViewCellDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addSubview(readersCollectionViewController.collectionView)
        readersCollectionViewController.collectionView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
    }
}

// MARK: - Helpers
extension AvailableReadersCollectionViewCell {
    
    private func configure() {
        guard let readers = readers,
              let readersRSSI = readersRSSI else { return }
        readersCollectionViewController.readers = readers
        readersCollectionViewController.readersRSSI = readersRSSI
        readersCollectionViewController.collectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let readersCollectionViewHeight = self.readersCollectionViewController.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewControllerHeight = readersCollectionViewHeight
        }
    }
}

// MARK: - ReadersCollectionViewControllerDelegate
extension AvailableReadersCollectionViewCell: ReadersCollectionViewControllerDelegate {
    
    func readersCollectionViewControllerDelegateDidSelectReader(withReader reader: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType) {
        delegate?.availableReadersCellDidSelectReader(withReader: reader, rssi: rssi, bluetoothType: bluetoothType)
    }
}
