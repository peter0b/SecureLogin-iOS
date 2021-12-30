//
//  BackgroudImageView.swift
//  GNS Secure Login
//
//  Created by Peter Bassem on 22/07/2021.
//

import UIKit

class BackgroudImageView: UIImageView {

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        
    }
    
    // MARK: - Private Configurations
    private func configure() {
        NotificationCenter.default.addObserver(self, selector: #selector(rotationDetected(_:)), name: UIDevice.orientationDidChangeNotification, object: nil)
        if UIDevice.current.orientation.isLandscape {
            contentMode = .scaleToFill
        } else {
            contentMode = .scaleAspectFill
        }
    }
    
    // MARK: - Private Selectors
    @objc
    private func rotationDetected(_ sender: Notification) {
        if UIDevice.current.userInterfaceIdiom == .phone {
            if UIDevice.current.orientation.isLandscape {
                contentMode = .scaleToFill
            } else {
                contentMode = .scaleAspectFill
            }
        } else {
            contentMode = .scaleToFill
        }
        setNeedsDisplay()
    }
}
