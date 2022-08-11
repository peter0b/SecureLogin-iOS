//
//  FormatBadgeViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 25/07/2021.
//

import UIKit
//import ACSSmartCardIO
//import CoreBluetooth

class FormatBadgeViewController: BaseViewController {
    
    // MARK: - Outlets
    
    // MARK: - Variables
    var presenter: FormatBadgePresenterProtocol!
    
//    let manager = BluetoothSmartCard.shared.manager
//    let factory = BluetoothSmartCard.shared.factory
//    let cardStateMonitor = CardStateMonitor.shared
//    let bluetoothManager = CBCentralManager(delegate: nil, queue: nil)

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
//        let bluetoothManager = BluetoothManager(manager: manager, factory: factory, cardStateMonitor: cardStateMonitor, bluetoothManager: bluetoothManager)
//        let cardChannel = bluetoothManager.getChardChannel()
//        if cardChannel != nil {
//            let card = cardChannel!.card
//            let miFareDesfireHelper = MiFareDesfireHelper(card: card, mifareNFCCardManager: ApduCommandExecuter())
//            miFareDesfireHelper.authenticate { apduResponse, error in
//                if let error = error {
//                    print("Authentication error:", error)
//                    return
//                }
//                print("Athentication Successfully:", apduResponse?.success ?? false)
//            }
//        } else {
//            print("Card not found")
//        }
    }
}

// MARK: - Helpers
extension FormatBadgeViewController {
    
}

// MARK: - Selectors
extension FormatBadgeViewController {
    
    @IBAction
    private func backButtonDidPressed(_ sender: UIButton) {
        presenter.performBack()
    }
    
    @IBAction
    private func noButtonDidPressed(_ sender: UIButton) {
        presenter.performBack()
    }
    
    @IBAction
    private func yesButtonDidPressed(_ sender: UIButton) {
        let bluetoothManager = BluetoothManager.getInstance()
        let cardChannel = bluetoothManager.getChardChannel()
        if cardChannel != nil {
            let card = cardChannel!.card
            let miFareDesfireHelper = MiFareDesfireHelper(card: card, mifareNFCCardManager: ApduCommandExecuter())
            miFareDesfireHelper.formatAndReconfigCard { [weak self] response, error in
                if let error = error {
                    print("Failed to format and config card:", error)
                    self?.showBottomMessage("format_fail".localized())
                    return
                }
                if response?.success == true {
                    self?.showBottomMessage("format_success".localized())
                    self?.presenter.performBack()
                }
            }
        } else {
            showBottomMessage("Please insert card to format.")
        }
    }
}
