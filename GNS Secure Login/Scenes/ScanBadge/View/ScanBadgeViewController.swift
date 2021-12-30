//
//  ScanBadgeViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 25/07/2021.
//

import UIKit
import ACSSmartCardIO
import CoreBluetooth

final class ScanBadgeViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var cardIsValidCheckImageView: UIImageView!
    @IBOutlet private weak var nextButton: UIButton!
    
    // MARK: - Variables
    var presenter: ScanBadgePresenterProtocol!
    var iCardStateMonitorListenerDelegate: ICardStateMonitorListenerDelegate!
    
    let manager = BluetoothSmartCard.shared.manager
    let factory = BluetoothSmartCard.shared.factory
    let cardStateMonitor = CardStateMonitor.shared
    let bluetoothManager = CBCentralManager(delegate: nil, queue: nil)
    
    var mBluetoothManager: BluetoothManager!
    private var readers: [CBPeripheral] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SCAN BADGE VIEWCONTROLLER")
        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        
        
//        if UIDevice.hasTopNotch {
//            print("->")
//            mBluetoothManager = BluetoothManager.getInstance(manager: manager, factory: factory, cardStateMonitor: cardStateMonitor, bluetoothManager: bluetoothManager)
//            mBluetoothManager.startScanForBLEDevices()
//            mBluetoothManager.bleManager()
//            mBluetoothManager.getAvailableNFCCards { [weak self] aReaders in
//                guard let self = self else { return }
//                self.readers = aReaders
//            }
//            
//            mBluetoothManager.onTerminalsAdded { [weak self] in
//                guard let self = self else { return }
//                if let savedReaderIdentifier = PersistentDataHelper.shared.readerPeripheral {
//                    if let savedReader = self.readers.first(where: { $0.identifier.uuidString == savedReaderIdentifier }) {
//                        self.connectReader(savedReader)
//                        print("Connected!!!")
//    //                    self.presenter.savedNFCCard = savedReader
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                            print("Trying to get NFC battery status..")
//                            self.mBluetoothManager.mTerminals!.forEach {
//                                if $0.name == (savedReader.name ?? "") {
//                                    do {
//                                        let batteryLevel = try self.mBluetoothManager.nfcManager.batteryLevel(terminal: $0, timeout: 10000)
//                                        if batteryLevel < 0 {
//                                            print("Battery Level: Not supported")
//                                        } else {
//                                            let batteryValueString = String(format: "%d%%", batteryLevel)
//                                            print("batteryValueString after autoconnect:", batteryValueString)
//                                            NotificationCenter.default.post(name: .NfcBatteryStatus, object: nil, userInfo: ["battery": batteryValueString])
//                                        }
//                                    } catch let error {
//                                        print("Failed to get battery level:", error)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        [cardIsValidCheckImageView, nextButton].forEach { $0.isHidden = !BluetoothManager.cardConnected }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        iCardStateMonitorListenerDelegate = ICardStateMonitorListenerDelegate({ [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                [self.cardIsValidCheckImageView, self.nextButton].forEach { $0.isHidden = false }
            }
        }, { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                [self.cardIsValidCheckImageView, self.nextButton].forEach { $0.isHidden = true }
            }
        })
        BluetoothManager.getInstance().iCardStateMonitorListener = iCardStateMonitorListenerDelegate
    }
    
    private func connectReader(_ reader: CBPeripheral) {
        mBluetoothManager.mTerminals!.forEach {
            if $0.name == (reader.name ?? "") {
                mBluetoothManager.cardTerminal = $0
                mBluetoothManager.connect(toPeripheral: reader)
                mBluetoothManager.getChardChannel()
                mBluetoothManager.stopScan()
            }
        }
    }
}

// MARK: - Selectors
extension ScanBadgeViewController {
    
    @IBAction
    private func backButtonDidPressed(_ sender: UIButton) {
        presenter.performBack()
    }
    
    @IBAction
    private func nextButtonDidPressed(_ sender: UIButton) {
        presenter.performNext()
    }
}
