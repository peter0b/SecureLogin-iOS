//
//  HomeViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 22/07/2021.
//

import UIKit
import ACSSmartCardIO
import CoreBluetooth

final class HomeViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    
    // MARK: - Variables
    var presenter: HomePresenterProtocol!
    private var tableViewDelegate: TableView<HomeItemTableViewCell>!
    
    let manager = BluetoothSmartCard.shared.manager
    let factory = BluetoothSmartCard.shared.factory
    let cardStateMonitor = CardStateMonitor.shared
    let bluetoothManager = CBCentralManager(delegate: nil, queue: nil)
    
    var mBluetoothManager: BluetoothManager!
    private var readers: [CBPeripheral] = []
    
    private var batteryLevelView: BatteryLevelView!

    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HOME VIEWCONTROLLER!!")
        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        setupTableView(withCell: HomeItemTableViewCell.self)
        
        // initializes bluetooth manager
        mBluetoothManager = BluetoothManager.getInstance(manager: manager, factory: factory, cardStateMonitor: cardStateMonitor, bluetoothManager: bluetoothManager)
        mBluetoothManager.startScanForBLEDevices()
        mBluetoothManager.bleManager()
        mBluetoothManager.getAvailableNFCCards { [weak self] aReaders in
            guard let self = self else { return }
            self.readers = aReaders
        }
        
        mBluetoothManager.onTerminalsAdded { [weak self] in
            guard let self = self else { return }
            if let savedReaderIdentifier = PersistentDataHelper.shared.readerPeripheral {
                if let savedReader = self.readers.first(where: { $0.identifier.uuidString == savedReaderIdentifier }) {
                    self.connectReader(savedReader)
                    print("Connected!!!")
                    self.presenter.savedNFCCard = savedReader
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        print("Trying to get NFC battery status..")
                        self.mBluetoothManager.mTerminals!.forEach {
                            if $0.name == (savedReader.name ?? "") {
                                do {
                                    let batteryLevel = try self.mBluetoothManager.nfcManager.batteryLevel(terminal: $0, timeout: 10000)
                                    if batteryLevel < 0 {
                                        print("Battery Level: Not supported")
                                    } else {
                                        let batteryValueString = String(format: "%d%%", batteryLevel)
                                        print("batteryValueString after autoconnect:", batteryValueString)
                                        NotificationCenter.default.post(name: .NfcBatteryStatus, object: nil, userInfo: ["battery": batteryValueString])
                                    }
                                } catch let error {
                                    print("Failed to get battery level:", error)
                                }
                            }
                        }
                    }
                }
            }
        }
        
//        mBluetoothManager.onTerminalsAdded { [weak self] in
//            guard let self = self else { return }
//            if let savedReaderIdentifier = PersistentDataHelper.shared.readerPeripheral {
//                if let savedReader = self.readers.first(where: { $0.identifier.uuidString == savedReaderIdentifier }) {
//                    print("self.mBluetoothManager.mTerminals count:", self.mBluetoothManager.mTerminals!.count)
//                    self.mBluetoothManager.mTerminals!.forEach {
//                        if $0.name == (savedReader.name ?? "") {
//                            self.mBluetoothManager.cardTerminal = $0
//                            self.mBluetoothManager.getChardChannel()
//                            self.mBluetoothManager.stopScan()
//                            do {
//                                let batteryLevel = try self.mBluetoothManager.nfcManager.batteryLevel(terminal: $0, timeout: 100000)
//                                if batteryLevel < 0 {
//                                    print("Battery Level: Not supported")
//                                } else {
//                                    let batteryValueString = String(format: "%d%%", batteryLevel)
//                                    print("batteryValueString after autoconnect:", batteryValueString)
//                                    NotificationCenter.default.post(name: .NfcBatteryStatus, object: nil, userInfo: ["battery": batteryValueString])
//                                }
//                            } catch let error {
//                                print("Failed to get battery level:", error)
//                            }
//                            print("connected")
//                        }
//                    }
//                }
//            }
//        }
        
        // connects automaticly to reader
//        mBluetoothManager.startScanForBLEDevices()
        
        NotificationCenter.default.addObserver(forName: .BadgeBatteryStatus, object: nil, queue: .main) { [weak self] notification in
            let dict = notification.userInfo
            let batteryLevel = dict?["battery"] as? String ?? ""
            print("Badge Battery Level in home:", batteryLevel)
            
            self?.batteryLevelView.badgeBatteryView.isHidden = false
            self?.batteryLevelView.badgeBatteryLabel.text = batteryLevel
        }
        
        NotificationCenter.default.addObserver(forName: .NfcBatteryStatus, object: nil, queue: .main) { [weak self] notification in
            let dict = notification.userInfo
            let batteryLevel = dict?["battery"] as? String ?? ""
            print("NFC Battery Level in home:", batteryLevel)
            
            self?.batteryLevelView.nfcBatteryView.isHidden = false
            self?.batteryLevelView.nfcBatteryLabel.text = batteryLevel
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let keyWindow = keyWindow else {
            print("No Keywindow!!!!!!")
            return
        }
        batteryLevelView = Bundle.loadView(withType: BatteryLevelView.self)
        keyWindow.addSubview(batteryLevelView)
        batteryLevelView.anchor(top: keyWindow.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: keyWindow.trailingAnchor)
        batteryLevelView.widthAnchor.constraint(equalTo: keyWindow.widthAnchor, multiplier: 0.5).isActive = true
        batteryLevelView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

// MARK: - Helpers
extension HomeViewController {
    
    func setupTableView<Cell: UITableViewCell, Header: UITableViewHeaderFooterView>(withCell cell: Cell.Type, header: Header.Type? = nil) {
        
        tableViewDelegate = TableView<HomeItemTableViewCell>(
            itemsCount: presenter.itemsCount,
            rowConfigurator: { [weak self] cell, itemIndex in
                self?.presenter.configureHomeItemCell(cell, atIndex: itemIndex)
            },
            rowSelector: { [weak self] itemIndex in
                self?.presenter.didSelectHomeItem(atIndex: itemIndex)
                if itemIndex == 0 {
                    self?.mBluetoothManager.getCardState()
                }
            },
            rowHeight: 92
        )
        tableView.dataSource = tableViewDelegate
        tableView.delegate = tableViewDelegate
        tableView.registerCell(cell: cell)
        if let header = header {
            tableView.registerHeader(header: header)
        }
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        OrientationManager.sharedManager.startObserving { [weak self] in
//            self?.tableView.visibleCells.forEach {
//                guard let cell = $0 as? HomeItemTableViewCell else { return }
//                cell.containerView.backgroundColor = DesignSystem.Colors.backgroundSecondary.color
//            }
        } handleLandscapeOrientation: { [weak self] in
//            self?.tableView.visibleCells.forEach {
//                guard let cell = $0 as? HomeItemTableViewCell else { return }
//                cell.containerView.backgroundColor = .white
//            }
        }
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
extension HomeViewController {
    
}
