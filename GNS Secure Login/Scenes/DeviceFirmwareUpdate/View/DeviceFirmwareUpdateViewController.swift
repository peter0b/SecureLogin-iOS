//
//  DeviceFirmwareUpdateViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 30/12/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import CoreBluetooth
import iOSDFULibrary

final class DeviceFirmwareUpdateViewController: BaseViewController {

    // MARK: - Outlets
    @IBOutlet private weak var applicationLabel: UILabel! {
        didSet { applicationLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] }
    }
    @IBOutlet private weak var dfuTitleLabel: UILabel! {
        didSet { dfuTitleLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] }
    }
    @IBOutlet private weak var fileNameLabel: UILabel! {
        didSet { fileNameLabel.text = String(format: "%@: ", "file_name".localized()) }
    }
    @IBOutlet private weak var sizeLabel: UILabel! {
        didSet { sizeLabel.text = String(format: "%@: ", "size".localized()) }
    }
    @IBOutlet private weak var statusLabel: UILabel! {
        didSet { statusLabel.text = String(format: "%@: %@", "status".localized(), "file_not_loaded".localized()) }
    }
    @IBOutlet private weak var uploadFileButton: UIButton! {
        didSet { uploadFileButton.configureButton(false) }
    }
    @IBOutlet private weak var uploadStatusLabel: UILabel!
    @IBOutlet private weak var uploadProgessView: UIProgressView!
    @IBOutlet private weak var uploadPorgressValueLabel: UILabel!
    
    // MARK: - Variables
	var presenter: DeviceFirmwareUpdatePresenterProtocol!
    
    private var dfuPeripheral: CBPeripheral!
    private var fileURL: URL? {
        didSet { setupInitialDFUData() }
    }
    private var selectedFirmware: DFUFirmware!

    // MARK: - Lifecycle
    init(dfuPeripheral: CBPeripheral) {
        self.dfuPeripheral = dfuPeripheral
        super.init()
    }
    
    required init?(coder: NSCoder) {
        self.dfuPeripheral = nil
        super.init(coder: coder)
    }
    
	override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
    }
}

// MARK: - Helpers
extension DeviceFirmwareUpdateViewController {
    
    private func setupInitialDFUData() {
        uploadFileButton.configureButton(true)
        selectedFirmware = DFUFirmware(urlToZipFile: fileURL!)
        fileNameLabel.text = String(format: "%@: %@", "file_name".localized(), selectedFirmware.fileName ?? "")
        sizeLabel.text = String(format: "%@: %d %@", "size".localized(), selectedFirmware.size.application, "bytes")
        statusLabel.text = String(format: "%@: %@", "status".localized(), "file_ok".localized())
    }
}

// MARK: - Selectors
extension DeviceFirmwareUpdateViewController {
    
    @IBAction
    private func backButtonDidPressed(_ sender: UIButton) {
        presenter.performBack()
    }
    
    @IBAction
    private func selectFileButtonDidPressed(_ sender: UIButton) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.zip-archive"], in: .import)
            documentPicker.delegate = self
            documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        self.present(documentPicker, animated: true, completion: nil)
    }
    
    @IBAction
    private func uploadFileButtonDidPressed(_ sender: UIButton) {
        uploadStatusLabel.isHidden = false
        
        let initiator = DFUServiceInitiator().with(firmware: selectedFirmware!)
        initiator.forceDfu = true
        initiator.logger = self
        initiator.delegate = self
        initiator.progressDelegate = self
        
        _ = initiator.start(target: dfuPeripheral)
    }
}

// MARK: - UIDocumentPickerDelegate
extension DeviceFirmwareUpdateViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true)
        self.fileURL = urls[0]
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        controller.dismiss(animated: true)
    }
}

// MARK: - LoggerDelegate
extension DeviceFirmwareUpdateViewController: LoggerDelegate {
    
    func logWith(_ level: LogLevel, message: String) {
        print("==> \(level.name()): \(message)")
    }
}

// MARK: - DFUServiceDelegate
extension DeviceFirmwareUpdateViewController: DFUServiceDelegate {
    
    func dfuStateDidChange(to state: DFUState) {
        uploadStatusLabel.text = state.description()
    }
    
    func dfuError(_ error: DFUError, didOccurWithMessage message: String) {
        print("DFU Failed with error: \(error.rawValue) message:", message)
    }
}

// MARK: - DFUProgressDelegate
extension DeviceFirmwareUpdateViewController: DFUProgressDelegate {
    
    func dfuProgressDidChange(for part: Int, outOf totalParts: Int, to progress: Int, currentSpeedBytesPerSecond: Double, avgSpeedBytesPerSecond: Double) {
        uploadProgessView.setProgress((Float(progress)/Float(100)), animated: true)
        uploadPorgressValueLabel.text = String(format: "%d%@", progress, "%")
    }
}
