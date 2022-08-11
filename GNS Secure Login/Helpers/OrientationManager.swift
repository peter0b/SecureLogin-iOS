//
//  OrientationManager.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 26/07/2021.
//

import Foundation
import UIKit

class OrientationManager {
    
    static var sharedManager = OrientationManager()
    private init() { }
    
    typealias PortraitOrientation = () -> Void
    typealias LandscapeOrientation = () -> Void
    
    private var handlePortraitOrientation: PortraitOrientation?
    private var handleLandscapeOrientation: LandscapeOrientation?
    
    func startObserving(handlePortraitOrientation: @escaping PortraitOrientation, handleLandscapeOrientation: @escaping LandscapeOrientation) {
        self.handlePortraitOrientation = handlePortraitOrientation
        self.handleLandscapeOrientation = handleLandscapeOrientation
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func stopObserving() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Private Selector
    @objc
    private func rotationDetected(_ sender: Notification) {
        if UIDevice.current.orientation.isPortrait {
            handlePortraitOrientation?()
        } else {
            handleLandscapeOrientation?()
        }
    }
}
