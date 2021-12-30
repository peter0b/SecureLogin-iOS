//
//  ImagePickerManager.swift
//  Login Location
//
//  Created by Peter Bassem on 2/13/19.
//  Copyright © 2019 Peter Bassem. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController()
    var alert = UIAlertController(title: "choose_image_source".localized(), message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage, URL?) -> ())?
    
    override init(){
        super.init()
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, URL?) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        
        let cameraAction = UIAlertAction(title: "camera".localized(), style: .default) {  _ in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "gallary".localized(), style: .default) { _ in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel)
        // Add the actions
        picker.delegate = self
        picker.allowsEditing = true
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            
            let alertWarning = UIAlertController(title: "warning".localized(), message: "noCamera".localized(), preferredStyle: .alert)
            let okButton = UIAlertAction(title: "ok".localized(), style: .default)
            alertWarning.addAction(okButton)
            viewController?.present(alertWarning, animated: true, completion: nil)
        }
    }
    
    func openGallery() {
        alert.dismiss(animated: true, completion: nil)
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let ref = info[UIImagePickerController.InfoKey.imageURL] as? URL
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            pickImageCallback?(editedImage, ref)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            pickImageCallback?(originalImage, ref)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
