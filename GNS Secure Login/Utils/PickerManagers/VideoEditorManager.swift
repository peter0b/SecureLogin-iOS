//
//  VideoEditorManager.swift
//  incadre
//
//  Created by Peter Bassem on 03/03/2021.
//  Copyright © 2021 Boo Doo. All rights reserved.
//

import Foundation
import UIKit

class VideoEditorManager: NSObject, UINavigationControllerDelegate, UIVideoEditorControllerDelegate {
    
    let videoEditor = UIVideoEditorController()
    var viewController: UIViewController?
    var editVideoCallback : ((URL?) -> ())?
    
    override init() {
        super.init()
    }
    
    func editVideo(_ viewController: UIViewController, videoPath: String, _ callback: @escaping ((URL?) -> ())) {
        editVideoCallback = callback
        self.viewController = viewController
        print("videoPath:", videoPath)
        videoEditor.videoPath = videoPath
        videoEditor.videoMaximumDuration = 15
        videoEditor.delegate = self
        viewController.present(videoEditor, animated: true, completion: nil)
    }
    
    func videoEditorController(_ editor: UIVideoEditorController, didSaveEditedVideoToPath editedVideoPath: String) {
        
//        editor.dismiss(animated: true, completion: nil)
        //Do whatever you wish with the trimmed video here
        videoEditor.delegate = nil
        print(editedVideoPath)
        fatalError()
    }
    
    func videoEditorController(_ editor: UIVideoEditorController, didFailWithError error: Error) {
        print("Failed to save trimmed video:", error)
        fatalError()
    }
    
    func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
        print("Cancelled")
        fatalError()
    }
    
    
}

