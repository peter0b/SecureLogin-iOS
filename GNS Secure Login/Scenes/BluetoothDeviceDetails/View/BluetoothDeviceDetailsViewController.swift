//
//  BluetoothDeviceDetailsViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 22/08/2021.
//

import UIKit
import CoreBluetooth

final class BluetoothDeviceDetailsViewController: BaseViewController {
    
    // MARK: - Outelts
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Variables
    var presenter: BluetoothDeviceDetailsPresenterProtocol!
    
    var ble: CBPeripheral!
    var rssi: NSNumber!
    var bluetoothType: BluetoothType!
    private var isConnected = false
    
    var bluetoothManager: BluetoothManager!
    
    private func connectReader(_ reader: CBPeripheral) {
        bluetoothManager.mTerminals!.forEach {
            if $0.name == (reader.name ?? "") {
                bluetoothManager.cardTerminal = $0
                bluetoothManager.getChardChannel()
                bluetoothManager.connect(toPeripheral: ble)
                bluetoothManager.getChardChannel()
                bluetoothManager.stopScan()
                print("ble connect")
                do {
                    let batteryLevel = try bluetoothManager.nfcManager.batteryLevel(terminal: $0, timeout: 10000)
                    if batteryLevel < 0 {
                        print("Battery Level: Not supported")
                    } else {
                        let batteryValueString = String(format: "%d%%", batteryLevel)
                        NotificationCenter.default.post(name: .NfcBatteryStatus, object: nil, userInfo: ["battery": batteryValueString])
                    }
                } catch let error {
                    print("Failed to get battery level:", error)
                }
            }
            PersistentDataHelper.shared.readerPeripheral = ble.identifier.uuidString
            PersistentDataHelper.shared.readerConnected = true
            isConnected = true
//            DispatchQueue.main.async { [weak self] in
//                self?.collectionView.reloadData()
//            }
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
        setupCollectionView()
        bluetoothManager = BluetoothManager.getInstance()
        if bluetoothType == .readers {
            if PersistentDataHelper.shared.readerConnected {
                if let savedReaderIdentifier = PersistentDataHelper.shared.readerPeripheral {
                    if savedReaderIdentifier == ble.identifier.uuidString {
                        connectReader(ble)
//                        self.bluetoothManager.mTerminals!.forEach { _ in
//                            connectReader(ble)
////                            if $0.name == (ble.name ?? "") {
////                                self.bluetoothManager.cardTerminal = $0
////                                self.bluetoothManager.getChardChannel()
////                                self.bluetoothManager.stopScan()
////                                self.isConnected = true
////                                print("connected")
////                            }
//                        }
                    }
                }
            }
        }
    }
}

// MARK: - Helpers
extension BluetoothDeviceDetailsViewController {
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: BluetoothDeviceHeaderCollectionViewCell.identifier, bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BluetoothDeviceHeaderCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: ActionItemCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ActionItemCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
    }
    
    
}

// MARK: - Selectors
extension BluetoothDeviceDetailsViewController {
    
}


// MARK: - UICollectionViewDataSource
extension BluetoothDeviceDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BluetoothDeviceHeaderCollectionViewCell.identifier, for: indexPath) as! BluetoothDeviceHeaderCollectionViewCell
        header.bluetoothDeviceNameLabel.text = ble.name ?? ""
        header.rssiLabel.text = "\("rssi".localized()) \(rssi ?? 0.0)"
        header.bluetoothType = bluetoothType
        header.delegate = self
        header.isOnSwitch.isOn = bluetoothManager.isPeripheralConnected
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bluetoothType == .badges ? BadgeActions.allCases.count: ReaderActions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ActionItemCollectionViewCell.identifier, for: indexPath) as! ActionItemCollectionViewCell
        switch bluetoothType {
        case .badges:
            cell.actionTitleLabel.text = BadgeActions.allCases[indexPath.item].rawValue.localized()
        case .readers:
            cell.actionTitleLabel.text = ReaderActions.allCases[indexPath.item].rawValue.localized()
        case .none: break
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension BluetoothDeviceDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if bluetoothManager.isPeripheralConnected {
        presenter.didSelectActionItem(withBluetoothDevice: ble, bluetoothType: bluetoothType, index: indexPath.item)
        } else {
            showBottomMessage("Badge not connected.")
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BluetoothDeviceDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.size.width, height: 153)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.size.width, height: 75)
    }
}

// MARK: - BluetoothDeviceHeaderCollectionViewCellDelegate
extension BluetoothDeviceDetailsViewController: BluetoothDeviceHeaderCollectionViewCellDelegate {
    
    func bluetoothDeviceHeaderCollectionViewCellBackButtonPressed() {
        presenter.performBack()
    }
    
    func connectReader() {
        connectReader(ble)
    }
    
    func disconnectReader() {
        bluetoothManager.disconnect(fromPeripheral: ble)
        bluetoothManager.stopScanForBLEDevices()
        PersistentDataHelper.shared.readerConnected = false
        isConnected = false
//        DispatchQueue.main.async { [weak self] in
//            self?.collectionView.reloadData()
//        }
        NotificationCenter.default.post(name: .NfcBatteryStatus, object: nil, userInfo: ["battery": -1])
    }
    
    func connectBadge() {
        bluetoothManager.connect(toPeripheral: ble)
    }
    
    func disconnectBadge() {
        bluetoothManager.disconnect(fromBadge: ble)
        NotificationCenter.default.post(name: .BadgeBatteryStatus, object: nil, userInfo: ["battery": -1])
    }
}
