//
//  FingerprintEnrollmentViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 25/08/2021.
//

import UIKit
import CoreBluetooth

final class FingerprintEnrollmentViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var fingerprintImageView: UIImageView!
    @IBOutlet private weak var statusLabel: UILabel!
    
    // MARK: - Variables
    var presenter: FingerprintEnrollmentPresenterProtocol!
    
    var ble: CBPeripheral!
    var bluetoothManager: BluetoothManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
        bluetoothManager = BluetoothManager.getInstance()
        observeVideoTutorialViewControllerSkipButton()
        observeVideoTutorialViewControllerCancelButton()
        observeEnrollmentValue()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.performShowVideoTutorialViewController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - Helpers
extension FingerprintEnrollmentViewController {
    
    private func observeVideoTutorialViewControllerSkipButton() {
        NotificationCenter.default.addObserver(forName: .VideTutorialSkipButton, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.bluetoothManager.startEnrollment(self.ble)
        }
    }
    
    private func observeVideoTutorialViewControllerCancelButton() {
        NotificationCenter.default.addObserver(forName: .VideTutorialCancelButton, object: nil, queue: .main) { [weak self] _ in
            self?.presenter.performBack()
        }
    }
    
    private func observeEnrollmentValue() {
        NotificationCenter.default.addObserver(forName: .EnrollmentValue, object: nil, queue: .main) { [weak self] notification in
            let dict = notification.userInfo
            let batteryLevel = dict?["enrollmentValue"] as? Int ?? -1
            switch batteryLevel {
            case 0: self?.updateUI(withImage: DesignSystem.Icon.fingerprint0.image, status: "first_finger.first_time".localized())
            case 1: self?.updateUI(withImage: DesignSystem.Icon.fingerprint1.image, status: "first_finger.second_time".localized())
            case 2: self?.updateUI(withImage: DesignSystem.Icon.fingerprint2.image, status: "first_finger.third_time".localized())
            case 3: self?.updateUI(withImage: DesignSystem.Icon.fingerprint3.image, status: "second_finger.first_time".localized())
            case 4: self?.updateUI(withImage: DesignSystem.Icon.fingerprint1.image, status: "second_finger.second_time".localized())
            case 5: self?.updateUI(withImage: DesignSystem.Icon.fingerprint2.image, status: "second_finger.third_time".localized())
            case 6:
                self?.updateUI(withImage: DesignSystem.Icon.fingerprint3.image, status: "enrollment_done_successfully".localized())
                self?.showBottomMessage("enrollment_done_successfully".localized())
                self?.presenter.performBack()
            default:
                self?.showBottomMessage("Something wrong happened!")
                self?.presenter.performBack()
            }
        }
    }
    
    private func updateUI(withImage image: UIImage, status: String?) {
        UIView.transition(with: fingerprintImageView, duration: 0.15, options: .transitionCrossDissolve) { [weak self] in
            self?.fingerprintImageView.image = image
        } completion: { _ in }
        statusLabel.text = status
    }
}

// MARK: - Selectors
extension FingerprintEnrollmentViewController {
    
    @IBAction
    private func backButtonDidPressed(_ sender: UIButton) {
        presenter.performBack()
    }
}
