//
//  ReadersCollectionViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 09/08/2021.
//

import UIKit
import CoreBluetooth

protocol ReadersCollectionViewControllerDelegate: AnyObject {
    func readersCollectionViewControllerDelegateDidSelectReader(withReader reader: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType)
}

final class ReadersCollectionViewController: BaseCollectionViewController {
    
    // MARK: - Variables
    var readers: [CBPeripheral] = []
    var readersRSSI: [NSNumber] = []
    
    var bluetoothManager: BluetoothManager!
    
    weak var delegate: ReadersCollectionViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        bluetoothManager = BluetoothManager.getInstance()
    }
}

// MARK: - Helpers
extension ReadersCollectionViewController {
    
    private func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.register(UINib(nibName: BluetoothItemCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: BluetoothItemCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func connectReader(_ reader: CBPeripheral) {
        bluetoothManager.mTerminals!.forEach {
            if $0.name == (reader.name ?? "") {
                bluetoothManager.cardTerminal = $0
                bluetoothManager.getChardChannel()
                bluetoothManager.stopScan()
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension ReadersCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        print("readers.count:", readers.count)
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
extension ReadersCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reader = readers[indexPath.item]
        let rssi = readersRSSI[indexPath.item]
        delegate?.readersCollectionViewControllerDelegateDidSelectReader(withReader: reader, rssi: rssi, bluetoothType: .readers)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ReadersCollectionViewController: UICollectionViewDelegateFlowLayout {
    
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
