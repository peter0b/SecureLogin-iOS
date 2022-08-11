//
//  GoogleMapsView.swift
//  MandoBee
//
//  Created by Peter Bassem on 27/07/2021.
//

import UIKit
#if canImport(GoogleMaps)
//import GoogleMaps
import CoreLocation

class GoogleMapsView: GMSMapView {

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Private Configuration
    private func configure() {
        
    }
    
    // MARK: - Update Map
    func setLocation(withLatitude: Double, longitude: Double) {
        
    }
    
    func setMarker(withLatitude: Double, longitude: Double) {
        
    }
}
#endif
