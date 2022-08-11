//
//  BaseTabBarViewController.swift
//  E-Council
//
//  Created by Peter Bassem on 9/17/20.
//  Copyright © 2020 Peter Bassem. All rights reserved.
//

import UIKit

class BaseTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}


extension BaseTabBarViewController: BaseViewProtocol {
    
    func showLoading() {
//        ActivityIndicatorManager.shared.showProgressView()
        view.isUserInteractionEnabled = false
        showSpinner(onView: view)
    }
    
    func hideLoading() {
//        ActivityIndicatorManager.shared.hideProgressView()
        view.isUserInteractionEnabled = true
        removeSpinner(fromView: view)
    }
    
    func showErrorAlert(error: String) {
        AlertView.AlertViewBuilder().setTitle(with: LocalizationSystem.sharedInstance.localizedStringForKey(key: "error", comment: ""))
            .setMessage(with: error)
            .setAlertType(with: .failure)
            .setButtonTitle(with: LocalizationSystem.sharedInstance.localizedStringForKey(key: "done", comment: ""))
            .build()
        return
    }
    
    func showErrorMessage(message: String) {
        ToastManager.shared.showError(message: message, view: self.view, completion: nil)
    }
    
    func showBottomMessage(_ message: String) {
        TTGSnackbarHelper.showSnackBar(inView: self.view, wihthLocationInView: .bottom, withMessage: message) { (_) in }
    }
}
