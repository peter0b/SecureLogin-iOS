//
//  EditApplicationCredentialsViewController+Delegates.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 27/12/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//

import UIKit
import Kingfisher

extension EditApplicationCredentialsViewController: EditApplicationCredentialsViewProtocol {
    
    func displayApplicationImage(fromImageURL imageUrl: URL) {
        _applicationImageView.kf.setImage(with: imageUrl)
    }
    
    func enableSaveButton() {
        _saveButton.configureButton(true)
    }
    
    func disableSaveButton() {
        _saveButton.configureButton(false)
    }
    
    func writeApplicationCredentials(sites: [SiteVM]) {
        mifareDesfireHelper.writeSitesToCard(card, sites: sites) { [unowned self] response, error in
            if let error = error {
                print("Failed to read site \(sites[0].code ?? ""):", error)
                return
            }
            self.showBottomMessage("Credentials updated successfully!")
            self.navigationController?.popViewController(animated: true)
        }
    }
}
