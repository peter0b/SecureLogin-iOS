//
//  SettingsViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 25/07/2021.
//

import UIKit
import CoreBluetooth

final class SettingsViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    
    var presenter: SettingsPresenterProtocol!
    private var readers: [CBPeripheral] = []
    private var readersRSSI: [NSNumber] = []
    var isReadersRefreshed = false
    var readersHeight: CGFloat = 0.0 {
        didSet { configureAvailableBadgesCellHeight() }
    }
    
    private var nfcs: [CBPeripheral] = []
    private var nfcsCardsRSSI: [NSNumber] = []
    var isNFCCardRefreshed = false
    var nfcsHeight: CGFloat = 0.0 {
        didSet { configureAvailbaleReadersCellHeight() }
    }
    var savedReader: CBPeripheral? {
        didSet {
            guard let savedReader = savedReader else { return }
            nfcs.append(savedReader)
        }
    }
    

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupCollectionView()
        
        BluetoothManager.getInstance().bleManager()
        
        savedReader?.readRSSI()
        savedReader?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        BluetoothManager.getInstance().startScanForBLEDevices()
        BluetoothManager.getInstance().getAvailableReaders { [weak self] aReaders in
            BluetoothManager.getInstance().getAvailableReadersRSSi { [weak self] aReadersRSSI in
                self?.readers = aReaders
                self?.readersRSSI = aReadersRSSI
                self?.collectionView.reloadItems(at: [IndexPath(item: 0, section: 0)])
            }
        }
        
        BluetoothManager.getInstance().getAvailableNFCCards { [weak self] aNFCs in
            BluetoothManager.getInstance().getAvailableNFCCardsRSSI { [weak self] aNFCCardsRSSI in
                self?.nfcs = aNFCs
                self?.nfcsCardsRSSI = aNFCCardsRSSI
                self?.collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Helpers
extension SettingsViewController {
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: SettingsCollectionViewCell.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SettingsCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: AvailableBadgesCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AvailableBadgesCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: AvailableReadersCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AvailableReadersCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
    }
    
    private func configureAvailableBadgesCellHeight() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if !self.isReadersRefreshed {
                self.collectionView.reloadData()
                self.isReadersRefreshed = true
            }
        }
    }
    
    private func configureAvailbaleReadersCellHeight() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if !self.isNFCCardRefreshed {
                self.collectionView.reloadData()
                self.isNFCCardRefreshed = true
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SettingsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SettingsCollectionViewCell.identifier, for: indexPath) as! SettingsCollectionViewCell
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return BluetoothType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch BluetoothType.allCases[indexPath.item] {
        case .badges:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailableBadgesCollectionViewCell.identifier, for: indexPath) as! AvailableBadgesCollectionViewCell
            cell.viewControllerReference = self
            cell.readers = readers
            cell.readersRSSi = readersRSSI
//            cell.badges = badgePeripherals
            cell.delegate = self
            return cell
        case .readers:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailableReadersCollectionViewCell.identifier, for: indexPath) as! AvailableReadersCollectionViewCell
            cell.viewControllerReference = self
            cell.readers = nfcs
            cell.readersRSSI = nfcsCardsRSSI
            cell.delegate = self
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SettingsViewController: UICollectionViewDelegate { }

// MARK: - UICollectionViewDelegateFlowLayout
extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.size.width, height: 113)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch BluetoothType.allCases[indexPath.item] {
        case .badges:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailableBadgesCollectionViewCell.identifier, for: indexPath) as! AvailableBadgesCollectionViewCell
            let height = cell.titleLabelHeight + 16 + readersHeight
            cell.layoutSubviews()
            return .init(width: collectionView.frame.size.width, height: height)
        case .readers:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AvailableReadersCollectionViewCell.identifier, for: indexPath) as! AvailableReadersCollectionViewCell
            let height = cell.titleLabelHeight + 16 + nfcsHeight
            cell.layoutSubviews()
            return .init(width: collectionView.frame.size.width, height: height)
        }
    }
}

// MARK: - SettingsCollectionViewCellDelegate
extension SettingsViewController: SettingsCollectionViewCellDelegate {
    
    func SettingsCollectionViewCellBackButtonPressed() {
        presenter.performBack()
    }
    
    func SettingsCollectionViewCellRefreshBluetoothDevicesButtonPressed() {
        
    }
}

// MARK: - AvailableBadgesCollectionViewCellDelegate
extension SettingsViewController: AvailableBadgesCollectionViewCellDelegate {
    
    func availableBadgesCellDidSelectBadge(withBadge badge: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType) {
        presenter.showBluetoothDeviceDetailsViewController(withBluetooth: badge, rssi: rssi, bluetoothType: bluetoothType)
    }
}

// MARK: - AvailableReadersCollectionViewCellDelegate
extension SettingsViewController: AvailableReadersCollectionViewCellDelegate {
    
    func availableReadersCellDidSelectReader(withReader reader: CBPeripheral, rssi: NSNumber, bluetoothType: BluetoothType) {
        PersistentDataHelper.shared.readerPeripheral = reader.identifier.uuidString
        presenter.showBluetoothDeviceDetailsViewController(withBluetooth: reader, rssi: rssi, bluetoothType: bluetoothType)
    }
}

extension SettingsViewController: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        nfcsCardsRSSI.append(RSSI)
    }
}
