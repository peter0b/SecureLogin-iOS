//
//  VideoPickerManager.swift
//  incadre
//
//  Created by Peter Bassem on 09/02/2021.
//  Copyright © 2021 Boo Doo. All rights reserved.
//

import Foundation
import UIKit
import MobileCoreServices
import Photos

class VideoPickerManager: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var picker = UIImagePickerController()
    var alert = UIAlertController(title: "choose_image_source".localized(), message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickVideoCallback : ((URL?, Bool) -> ())?
    
    override init(){
        super.init()
    }
    
    func pickVideo(_ viewController: UIViewController, _ callback: @escaping ((URL?, Bool) -> ())) {
        pickVideoCallback = callback
        self.viewController = viewController
        let gallaryAction = UIAlertAction(title: "gallary".localized(), style: .default) { _ in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel)
        // Add the actions
        picker.delegate = self
        picker.mediaTypes = [kUTTypeMovie as String]
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
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
        if let asset = info[.phAsset] as? PHAsset {
            getUrl(fromPHAsset: asset) { [weak self] (url) in
                guard let self = self else { return }
                print(1)
                self.checkURLLength(inPickecView: picker, url: url)
            }
        } else if let url = info[.mediaURL] as? URL {
            print(2)
            checkURLLength(inPickecView: picker, url: url)
        } else if let referenceURL = info[.referenceURL] as? URL {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [referenceURL], options: nil)
            if let asset = assets.firstObject {
                getUrl(fromPHAsset: asset) { [weak self] (url) in
                    guard let self = self else { return }
                    print(3)
                    self.checkURLLength(inPickecView: picker, url: url)
                }
            }
        }
    }
    
    private func getUrl(fromPHAsset asset: PHAsset, callBack: @escaping (_ url: URL?) -> Void) {
        asset.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { (contentEditingInput, _) in
            if let strURL = (contentEditingInput!.audiovisualAsset as? AVURLAsset)?.url.absoluteString {
                callBack(URL.init(string: strURL))
            }
        }
    }
    
    private func checkURLLength(inPickecView picker: UIImagePickerController, url: URL?) {
        guard let url = url else { return }
        picker.dismiss(animated: true, completion: nil)
        let asset = AVAsset(url: url)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        if durationTime > 15 {
            if UIVideoEditorController.canEditVideo(atPath: url.absoluteString) {
                pickVideoCallback?(url, false)
            }
        } else {
            pickVideoCallback?(url, true)
        }
    }
}
