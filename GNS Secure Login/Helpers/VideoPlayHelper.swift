//
//  VideoPlayHelper.swift
//  MandoBee
//
//  Created by Peter Bassem on 17/06/2021.
//

import Foundation
import UIKit
import AVFoundation

class VideoPlayHelper {
    
    private static var videoEndsCompletion: (() -> Void)?
    
    class func playLocalVideo(videoPath path: String?, inView view: UIView, completion: @escaping () -> Void) {
        guard let videoPath = path else {
            print("failed to get video path url")
            return
        }
        videoEndsCompletion = completion
        let videoURL = URL(fileURLWithPath: videoPath)
        let player = AVPlayer(url: videoURL)
        let layer = AVPlayerLayer(player: player)
        layer.frame = view.bounds
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        player.play()
        NotificationCenter.default.addObserver(self, selector: #selector(playerVideoDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    class func playOnlineVideo(videoPath path: String?, inView view: UIView, completion: @escaping () -> Void) {
        print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
        print("Trying to play video from string url:", path ?? "")
        guard let videoPath = path else {
            print("failed to get video path url")
            return
        }
        videoEndsCompletion = completion
        guard let videoURL = URL(string: videoPath) else {
            print("Failed to convert url string to URL.")
            return
        }
        print("Video URL:", videoURL)
        let player = AVPlayer(url: videoURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(playerLayer)
        player.play()
        NotificationCenter.default.addObserver(self, selector: #selector(playerVideoDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc
    private static func playerVideoDidFinishPlaying(_ sender: Notification) {
        VideoPlayHelper.videoEndsCompletion?()
    }
}
