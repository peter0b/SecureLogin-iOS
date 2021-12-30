//
//  FingerprintVideoTutorialViewController.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 29/08/2021.
//

import UIKit

final class FingerprintVideoTutorialViewController: BaseViewController {
    
    // MARK: - Outlets
    @IBOutlet private weak var videoPlayerView: UIView!
    
    // MARK: - Variables
    var presenter: FingerprintVideoTutorialPresenterProtocol!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //
        let path = Bundle.main.path(forResource: "Enrollment_Tutorial", ofType: "mp4")
        VideoPlayHelper.playLocalVideo(videoPath: path, inView: videoPlayerView) { [weak self] in
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
            print("Video Completed!!!!!!!!!")
            NotificationCenter.default.post(name: .VideTutorialSkipButton, object: nil, userInfo: nil)
            self?.presenter.performDismiss()
            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
        }
        
//        let videoUrl = "https://firebasestorage.googleapis.com/v0/b/lol-videos-8dc74.appspot.com/o/Blog_Images%2Fvideo%3A10142?alt=media&token=9f7734fa-f714-4838-bd65-8a4d594ec2ce"
//        VideoPlayHelper.playOnlineVideo(videoPath: videoUrl, inView: videoPlayerView) {
//            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
//            print("Video Completed!!!!!!!!!")
//            print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
//        }
    }
}

// MARK: - Helpers
extension FingerprintVideoTutorialViewController {
    
}

// MARK: - Selectors
extension FingerprintVideoTutorialViewController {
    
    @IBAction
    private func skipButtonDidPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: .VideTutorialSkipButton, object: nil, userInfo: nil)
        presenter.performDismiss()
    }
    
    @IBAction
    private func cancelButtonDidPressed(_ sender: UIButton) {
        NotificationCenter.default.post(name: .VideTutorialCancelButton, object: nil, userInfo: nil)
        presenter.performDismiss()
    }
}
