//
//  AvailableBadgesCollectionViewCell.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 08/08/2021.
//

import UIKit
import CoreBluetooth

protocol AvailableBadgesCollectionViewCellDelegate: AnyObject {
    func availableBadgesCellDidSelectBadge(withBadge badge: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType)
}

final class AvailableBadgesCollectionViewCell: BaseCollectionViewCell {
    
    // MARK: - Identifier
    static let identifier = "AvailableBadgesCollectionViewCell"
    
    // MARK: - Outlets
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: - Variables
    var readers: [CBPeripheral]? {
        didSet { configure() }
    }
    
    var readersRSSi: [NSNumber]? {
        didSet { configure() }
    }
    
//    var badges: [Peripheral]?
    
    var titleLabelHeight: CGFloat {
        return titleLabel.frame.size.height
    }
    
    private lazy var badgesCollectionViewController: BadgesCollectionViewController = {
        let collectionViewController = BadgesCollectionViewController()
        collectionViewController.delegate = self
        return collectionViewController
    }()
    
    weak var viewControllerReference: SettingsViewController?
    private var collectionViewControllerHeight: CGFloat? {
        didSet {
            viewControllerReference?.isReadersRefreshed = false
            viewControllerReference?.readersHeight = collectionViewControllerHeight ?? 0.0
        }
    }
    
    weak var delegate: AvailableBadgesCollectionViewCellDelegate?

    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        addSubview(badgesCollectionViewController.collectionView)
        badgesCollectionViewController.collectionView.anchor(top: titleLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 8, left: 0, bottom: 0, right: 0))
    }
}

// MARK: - Helpers
extension AvailableBadgesCollectionViewCell {
    
    private func configure() {
        guard let readers = readers,
              let readersRSSI = readersRSSi else { return }
        badgesCollectionViewController.readers = readers
        badgesCollectionViewController.readersRSSI = readersRSSI
        badgesCollectionViewController.collectionView.reloadData()
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            let badgesCollectionViewHeight = self.badgesCollectionViewController.collectionView.collectionViewLayout.collectionViewContentSize.height
            self.collectionViewControllerHeight = badgesCollectionViewHeight
        }
    }
}

// MARK: - BadgesCollectionViewControllerDelegate
extension AvailableBadgesCollectionViewCell: BadgesCollectionViewControllerDelegate {
    
    func badgesCollectionViewControllerDidSelectBadge(withBadge badge: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType) {
        delegate?.availableBadgesCellDidSelectBadge(withBadge: badge, rssi: rssi, bluetoothType: bluetoothType)
    }
}
