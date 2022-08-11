//
//  BluetoothManger.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 26/07/2021.
//

import Foundation
import SmartCardIO
import ACSSmartCardIO
import CoreBluetooth

protocol ICardConnectListener: AnyObject {
    func onConnectionResult(cardStatus: CardStatus, status: Bool, value: Any)
}

protocol ICardStateMonitorListener: AnyObject {
    func onCardInserted()
    func onCardRemoved()
}

class BluetoothManager: NSObject {
    
    private static var shared: BluetoothManager!
    
    private  var manager: BluetoothTerminalManager
    private var factory: TerminalFactory
    private var cardStateMonitor: CardStateMonitor
    private var readerScanResults = [CBPeripheral]()
    private var readerScansRSSI = [NSNumber]()
    
    private var cardScanResults = [CBPeripheral]()
    private var cardScansRSSI: [NSNumber] = []
    
    var nfcManager: BluetoothTerminalManager {
        return manager
    }
    
    var cardTerminal: CardTerminal? = nil
    var bluetoothManager: CBCentralManager
    private(set) var isPeripheralConnected = false
    var mTerminals: [CardTerminal]? = []
//    var cardTerminal: CardTerminal? = nil
    
    private(set) static var cardConnected = false
    
    weak var iCardConnectListener: ICardConnectListener?
    weak var iCardStateMonitorListener: ICardStateMonitorListener?
    
    var readers: (([CBPeripheral]) -> Void)?
    var readersRSSI: (([NSNumber]) -> Void)?
    var nfcs: (([CBPeripheral]) -> Void)?
    var nfcsRSSI: (([NSNumber]) -> Void)?
    var terminalsAdded: (() -> Void)?
    
    private let LIST_NAME = "NAME"
    private let LIST_UUID = "UUID"
    
    static var startEnrollment = false
    
    
    func getAvailableReaders(completion: @escaping (([CBPeripheral]) -> Void)) {
        self.readers = completion
    }
    
    func getAvailableReadersRSSi(completion: @escaping (([NSNumber]) -> Void)) {
        self.readersRSSI = completion
    }
    
    func getAvailableNFCCards(completion: @escaping (([CBPeripheral]) -> Void)) {
        self.nfcs = completion
    }
    
    func getAvailableNFCCardsRSSI(completion: @escaping (([NSNumber]) -> Void)) {
        self.nfcsRSSI = completion
    }
    
    func onTerminalsAdded(completion: (() -> Void)?) {
        self.terminalsAdded = completion
    }
    
    static func getInstance(manager: BluetoothTerminalManager? = nil, factory: TerminalFactory? = nil, cardStateMonitor: CardStateMonitor? = nil, bluetoothManager: CBCentralManager? = nil) -> BluetoothManager {
        if shared == nil {
            shared = BluetoothManager(manager: manager!, factory: factory!, cardStateMonitor: cardStateMonitor!, bluetoothManager: bluetoothManager!)
        }
        return shared
    }
    
    private init(manager: BluetoothTerminalManager, factory: TerminalFactory, cardStateMonitor: CardStateMonitor, bluetoothManager: CBCentralManager) {
        self.manager = manager
        self.factory = factory
        self.cardStateMonitor = cardStateMonitor
        self.bluetoothManager = bluetoothManager
    }
    
    func bleManager() {
        initBluetoothManger()
        initScan()
        setSettings()
        initCardState()
    }
    
    private func initBluetoothManger() {
        DispatchQueue.main.async { [weak self] in
            self?.manager.delegate = self //BluetoothManagerDelegate()
        }
    }
    
    private func initScan() {
        startScan()
        stopScan()
    }
    
    /// Start the scan.
    private func startScan() {
        DispatchQueue.main.async { [weak self] in
            self?.manager.startScan(terminalType: .acr1255uj1v2)
        }
    }
    
    /// Stop the scan.
    func stopScan() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            self?.manager.stopScan()
        }
    }
    
    private func detectTerminal(_ terminal: CardTerminal) {
        print("\(#function)")
        if readerScanResults.count > 0 {
            let result = readerScanResults[0].name
            if (result ?? "").lowercased().contains(terminal.name.lowercased()) {
                readerScanResults.remove(at: 0)
                mTerminals?.removeAll()
                mTerminals?.append(terminal)
                print("mTerminals incremented")
                terminalsAdded?()
            }
        }
    }
    
    /// Initialize List.
    private func initList() {
        mTerminals?.removeAll()
        do {
            let terminals = try factory.terminals().list()
            terminals.forEach {
                mTerminals?.append($0)
            }
        } catch let error {
            print("Failed to list terminals:", error)
        }
    }
    
    func connect(toPeripheral perhipheral: CBPeripheral) {
        bluetoothManager.connect(perhipheral, options: nil)
        perhipheral.discoverServices([SampleGattAttributes.BLE_BATTERY_SERVICE_UUID])
        perhipheral.delegate = self
    }
    
    func getServices(forPeripheral peripheral: CBPeripheral) {
        print("\(String(describing: peripheral.name)) services count: \(String(describing: peripheral.services?.count))")
    }
    
    /// Initialize Disconnect.
    func disconnect(fromPeripheral peripheral: CBPeripheral) {
        //Get the selected card terminal.
        let index = 0
        if index < (mTerminals?.count ?? 0) {
            let terminal = mTerminals?[index]
            DispatchQueue.global().async { [weak self] in
                // Remove the terminal from card state monitor.
                self?.cardStateMonitor.removeTerminal(terminal!)
                self?.bluetoothManager.cancelPeripheralConnection(peripheral)
                
                // Disconnect from the terminal.
                do {
                    try self?.manager.disconnect(terminal: terminal!)
                } catch let error {
                    print("Failed to disconnect terminal:", error)
                }
            }
        }
    }
    
    func disconnect(fromBadge badge: CBPeripheral) {
        bluetoothManager.cancelPeripheralConnection(badge)
    }
    
    /// Initialize the card state monitor.
    private func initCardState() {
        cardStateMonitor.delegate = self
    }
    
    /// Show or hide the card state.
    func getCardState() {
        /// Get the selected card terminal.
        let index = 0
        if index != -1 {
            // Show or hide the card state.
            if (mTerminals?.count ?? 0) > 0 {
                let terminal = mTerminals?[index]
                if cardStateMonitor.isTerminalEnabled(terminal!) {
                    cardStateMonitor.removeTerminal(terminal!)
                } else {
                    cardStateMonitor.addTerminal(terminal!)
                }
            } else {
                print("No Terminals connected")
            }
        }
    }
    
    /// Set settings.
    private func setSettings() {
        let keyPrefT0GetResponse = true
        let keyPrefT1GetResponse = true
        let keyPrefT1StripLe = false
        
        TransmitOptions.t0GetResponse = keyPrefT0GetResponse
        TransmitOptions.t1GetResponse = keyPrefT1GetResponse
        TransmitOptions.t1StripLe = keyPrefT1StripLe
    }
    
    /// Returns the description from the battery status.
    ///
    /// - Since: 0.4
    /// - Parameter batteryStatus: the battery status
    /// - Returns: the description
    private func toBatteryStatusString(batteryStatus: BluetoothTerminalManager.BatteryStatus) -> String {
        var string: String
        switch batteryStatus {
        case .notSupported: string = "Not supported"
        case .none: string = "No battery"
        case .low: string = "Low"
        case .full: string = "Full"
        case .usbPlugged: string = "USB plugged"
        @unknown default: string = "Unknown Error"
        }
        return string
    }
    
    /// Get the selected card terminal.
    @discardableResult
    func getChardChannel() -> CardChannel? {
        if mTerminals != nil && (mTerminals?.count ?? 0) > 0 {
            do {
                let card = try cardTerminal?.connect(protocolString: "*")
                return try card?.basicChannel()
            } catch let error {
                print("Failed to get chard channel:", error)
                return nil
            }
        } else {
            return nil
        }
    }
    
    /// Scan bluetooth devices.
    func startScanForBLEDevices() {
        //manager?.scanForPeripherals(withServices: [CBUUID.init(string: parentView!.BLEService)], options: nil)
        
        //if you pass nil in the first parameter, then scanForPeriperals will look for any devices.
        DispatchQueue.main.async {
            if self.bluetoothManager.state == .poweredOn {
                self.bluetoothManager.delegate = self
                self.bluetoothManager.scanForPeripherals(withServices: nil, options: nil) // [CBCentralManagerScanOptionAllowDuplicatesKey:true]
            }
        }
    }
    
    internal func stopScanForBLEDevices() {
        bluetoothManager.stopScan()
    }
}

// MARK: - BluetoothTerminalManagerDelegate (manager delegate)
extension BluetoothManager: BluetoothTerminalManagerDelegate {
    
    func bluetoothTerminalManagerDidUpdateState(_ manager: BluetoothTerminalManager) {
        print("manager.centralManager.state.rawValue:", manager.centralManager.state.rawValue)
        switch manager.centralManager.state {
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
            DispatchQueue.main.async { [weak self] in
                self?.bluetoothManager.stopScan()
            }
        case .poweredOn:
            print("poweredOn")
            DispatchQueue.main.async { [weak self] in
                self?.bluetoothManager.scanForPeripherals(withServices: nil, options: nil)
            }
        @unknown default: print("unknowon")
        }
    }
    
    func bluetoothTerminalManager(_ manager: BluetoothTerminalManager, didDiscover terminal: CardTerminal) {
        detectTerminal(terminal)
    }
}

extension BluetoothManager: CardStateMonitorDelegate {
    
    func cardStateMonitor(_ monitor: CardStateMonitor, didChangeState terminal: CardTerminal, prevState: CardStateMonitor.CardState, currState: CardStateMonitor.CardState) {
        if prevState.rawValue > CardStateMonitor.CardState.absent.rawValue
            && currState.rawValue <= CardStateMonitor.CardState.absent.rawValue {
            print(terminal.name + ": removed")
            BluetoothManager.cardConnected = false
            iCardStateMonitorListener?.onCardRemoved()
        } else if prevState.rawValue <= CardStateMonitor.CardState.absent.rawValue
            && currState.rawValue > CardStateMonitor.CardState.absent.rawValue {
            print(terminal.name + ": inserted")
            BluetoothManager.cardConnected = true
            iCardStateMonitorListener?.onCardInserted()
        }
    }
}

// MARK: - CBCentralManagerDelegate (Ble delegate)
extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) { print("central updated:", central) }
    
    /// This function is used to display newarby BLE Devices which are not connected yet.
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
//        print(peripheral)
        let readerIndexQuery = readerScanResults.firstIndex(of: peripheral)
        if readerIndexQuery != nil && readerIndexQuery != -1 { // A scan result already exists with the same address
            if RSSI.intValue >= -85 {
                readerScansRSSI.append(RSSI)
                readerScanResults[readerIndexQuery!] = peripheral
                nfcs?(readerScanResults)
                nfcsRSSI?(readerScansRSSI)
            } else {
                readerScanResults.remove(at: readerIndexQuery!)
                initScan()
            }
        } else {
            if peripheral.name != nil {
                if peripheral.name!.lowercased().contains("ACR1255U".lowercased()) {
                    readerScansRSSI.append(RSSI)
                    readerScanResults.append(peripheral)
                    nfcs?(readerScanResults)
                    nfcsRSSI?(readerScansRSSI)
                    initScan()
                }
            }
        }
        
        let cardIndexQuery = cardScanResults.firstIndex(of: peripheral)
        if cardIndexQuery != nil && cardIndexQuery != -1 { // A scan result already exists with the same address
            cardScansRSSI.append(RSSI)
            cardScanResults[cardIndexQuery!] = peripheral
            readers?(cardScanResults)
            readersRSSI?(cardScansRSSI)
        } else {
            if peripheral.name != nil {
                if peripheral.name!.lowercased().contains("STAR".lowercased()) {
                    cardScansRSSI.append(RSSI)
                    cardScanResults.append(peripheral)
                    readers?(cardScanResults)
                    readersRSSI?(cardScansRSSI)
                }
            }
        }
    }
    
    func startEnrollment(_ peripheral: CBPeripheral) {
        peripheral.discoverServices([SampleGattAttributes.BLE_GENERAL_SERVICE_UUID])
        peripheral.delegate = self
    }
    
    func startSTSafe(_ peripheral: CBPeripheral) {
        print("\(#function)")
        peripheral.discoverServices([SampleGattAttributes.BLE_STSAFE_UNLOCK])
        peripheral.delegate = self
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if (peripheral.name ?? "").lowercased().contains("STAR".lowercased()) || (peripheral.name ?? "").lowercased().contains("ACR1255U".lowercased()) {
//            peripheral.discoverServices([SampleGattAttributes.BLE_BAGE_ID_UUID, SampleGattAttributes.BLE_BATTERY_SERVICE_UUID])
            peripheral.discoverServices(nil)
            peripheral.delegate = self
            print("*******************************************************")
            print("\(peripheral.name ?? "") with identifier: \(peripheral.identifier) CONNECTED!!!!")
            isPeripheralConnected = true
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if (peripheral.name ?? "").lowercased().contains("STAR".lowercased()) {
            print("*******************************************************")
            print("\(peripheral.name ?? "") with identifier: \(peripheral.identifier) DISCONNECTED!!!!")
            isPeripheralConnected = false
        }
    }
}

// MARK: - CBPeripheralDelegate
extension BluetoothManager: CBPeripheralDelegate {
    
    func titleForUUID(_ uuid:CBUUID) -> String {
        var title = uuid.description
        if (title.hasPrefix("Unknown")) {
            title = uuid.uuidString
        }
        return title
    }
    
    private func gattCharacteristicGroupData(characteristics: [CBCharacteristic]) -> [[String: String]] {
        var chars: [CBCharacteristic] = []
        var gattCharacteristicGroupData: [[String: String]] = []
        for gattCharacteristic in characteristics {
            chars.append(gattCharacteristic)
            var currentCharaData: [String: String] = [:]
            let uuid = gattCharacteristic.uuid.uuidString
            currentCharaData[LIST_NAME] = SampleGattAttributes.lookup(uuid: uuid, defaultName: "Unknown characteristic")
            currentCharaData[LIST_UUID] = uuid
            gattCharacteristicGroupData.append(currentCharaData)
        }
        print("gattCharacteristicGroupData:", gattCharacteristicGroupData)
        return gattCharacteristicGroupData
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("*******************************************************")
        guard let services = peripheral.services else {
            print("No Services found!!!")
            return
        }
        print("Found \(services.count) Services.")
        services.forEach { service in
            if titleForUUID(service.uuid).lowercased().contains(SampleGattAttributes.BLE_GENERAL_SERVICE_UUID.uuidString.lowercased()) {
                peripheral.discoverCharacteristics(nil, for: service)
            } else if titleForUUID(service.uuid).lowercased().contains("battery") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Failed to discover characteristics:", error)
            return
        }
        print("*******************************************************")
        guard let characteristics = service.characteristics else {
            print("Characteristics not Found!!!")
            return
        }
        
        print("Service in \(#function):", service.uuid.uuidString)
        print("Found \(characteristics.count) characteristics.")
        
        if SampleGattAttributes.BLE_GENERAL_SERVICE_UUID.uuidString.contains(service.uuid.uuidString) {
            characteristics.forEach {
                if $0.uuid.isEqual(SampleGattAttributes.BLE_BAGE_ID_UUID) {
                    SampleGattAttributes.batteryCharacteristic = $0
                    peripheral.readValue(for: $0)
                }
            }
            if BluetoothManager.startEnrollment {
                // Fingerprint Enrollment
                print("Found Fingerprint Services: \(characteristics.count) characteristics.")
                
                var enrollCharacteristicUid = ""
                var enrollFeedbackCharacteristicUid = ""
                gattCharacteristicGroupData(characteristics: characteristics).forEach {
                    if $0[LIST_NAME] == ENROLL_CHARACTERISTIC_UID {
                        enrollCharacteristicUid = $0[LIST_UUID] ?? ""
                    }
                    if $0[LIST_NAME] == ENROLL_FEEDBACK_CHARACTERISTIC_UID {
                        enrollFeedbackCharacteristicUid = $0[LIST_UUID] ?? ""
                    }
                }
                
                let character = characteristics.filter { $0.uuid.uuidString == enrollCharacteristicUid || $0.uuid.uuidString.contains(enrollCharacteristicUid) }.first
                let feedbackCharacter = characteristics.filter { $0.uuid.uuidString == enrollFeedbackCharacteristicUid || $0.uuid.uuidString.contains(enrollFeedbackCharacteristicUid) }.first
                
                let enrollCommand: UInt8 = 0x57
                peripheral.setNotifyValue(true, for: feedbackCharacter!)
                
                let enrollmentCommandData = Data([enrollCommand])
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    peripheral.writeValue(enrollmentCommandData, for: character!, type: .withResponse)
                }
            }
        } else if SampleGattAttributes.BLE_BATTERY_SERVICE_UUID.uuidString.contains(service.uuid.uuidString) {
            // Battery Service
            print("Found Battery Services: \(characteristics.count) characteristics.")
            characteristics.forEach {
                if $0.uuid.isEqual(SampleGattAttributes.BLE_BATTERY_LEVEL_UUID) {
//                    device.read(characteristic: $0)
                    peripheral.readValue(for: $0)
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//        print("descriptords:", characteristic.descriptors)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            print("Failed to update value for characteristics:", error)
            return
        }
        print("*******************************************************")
        if SampleGattAttributes.BLE_BAGE_ID_UUID.isEqual(characteristic.uuid) {
            if let value = characteristic.value {
                NotificationCenter.default.post(name: .BadgeIdValue, object: nil, userInfo: ["badgeId": value.hexString])
            }
        } else if SampleGattAttributes.BLE_BATTERY_LEVEL_UUID.isEqual(characteristic.uuid) {
//            guard SampleGattAttributes.batteryCharacteristic != nil else {
//                print("No Charecteristics Found")
//                return
//            }
            let batteryValue = characteristic.value?.first ?? 0
            let batteryValueString = String(format: "%d%%", batteryValue)
            NotificationCenter.default.post(name: .BadgeBatteryStatus, object: nil, userInfo: ["battery": batteryValueString])
        } else if characteristic.uuid.uuidString == "59DE" || characteristic.uuid.uuidString.contains("59DE") {
            let enrolmmentValue = characteristic.value?.first ?? 0
            let enrollmentValueInt = Int(enrolmmentValue)
            NotificationCenter.default.post(name: .EnrollmentValue, object: nil, userInfo: ["enrollmentValue": enrollmentValueInt])
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Error discovering services: error")
            return
        }
        print("Function: \(#function),Line: \(#line)")
        print("Message sent")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("*******************************************************")
        print("Function: \(#function),Line: \(#line)")
        print("Characteristics:", characteristic)
        if (error != nil) {
            print("Error changing notification state:\(String(describing: error?.localizedDescription))")
            
        } else {
            print("Characteristic's value subscribed")
        }
        
        if (characteristic.isNotifying) {
            print ("Subscribed. Notification has begun for: \(characteristic.uuid)")
        }
    }
}
