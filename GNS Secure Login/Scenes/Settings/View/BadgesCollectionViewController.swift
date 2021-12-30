//
//  BadgesCollectionViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 09/08/2021.
//

import UIKit
import CoreBluetooth

protocol BadgesCollectionViewControllerDelegate: AnyObject {
    func badgesCollectionViewControllerDidSelectBadge(withBadge badge: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType)
}

final class BadgesCollectionViewController: BaseCollectionViewController {
    
    // MARK: - Variables
    var readers: [CBPeripheral] = []
    var readersRSSI: [NSNumber] = []
    
    weak var delegate: BadgesCollectionViewControllerDelegate?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
    }
}

// MARK: - Helpers
extension BadgesCollectionViewController {
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: BluetoothItemCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BluetoothItemCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
    }
}

// MARK: - UICollectionViewDataSource
extension BadgesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return readers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BluetoothItemCollectionViewCell.identifier, for: indexPath) as! BluetoothItemCollectionViewCell
        cell.bleItem = readers[indexPath.item]
        cell.rssiValue = readersRSSI[indexPath.item]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension BadgesCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let badge = readers[indexPath.item]
        let rssi = readersRSSI[indexPath.item]
        delegate?.badgesCollectionViewControllerDidSelectBadge(withBadge: badge, rssi: rssi, bluetoothType: .badges)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BadgesCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
