//
//  LocationService.swift
//  MandoBee
//
//  Created by Peter Bassem on 10/07/2021.
//

import Foundation
import UIKit
import CoreLocation

protocol LocationServiceDelegate: AnyObject {
    func requestLocation()
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

enum CameraZoom: Int {
    case world = 1
    case landmass = 5
    case city = 10
    case streets = 15
    case buidings = 20
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationService() // Simple, Short & Sweet :)
    private var locationManager: CLLocationManager?
    private var lastLocation: CLLocation?
    weak var delegate: LocationServiceDelegate?

    override init() {
        super.init()

        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            // you have 2 choice
            // 1. requestAlwaysAuthorization
            // 2. requestWhenInUseAuthorization
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest // The accuracy of the location data
        locationManager.distanceFilter = 200 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
    }
    
    func checkAuthorization() {
        if CLLocationManager.authorizationStatus() == .denied {
            delegate?.requestLocation()
        }
    }
    
    func startUpdatingLocation() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.last else {
            return
        }
        
        // singleton for get last location
        self.lastLocation = location
        
        // use for real time update location
        updateLocation(currentLocation: location)
    }
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        // do on error
        updateLocationDidFailWithError(error: error)
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){

        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
}
