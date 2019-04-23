//
//  LocationVM.swift
//  Geofencing
//
//  Created by Abhishek Salokhe on 23/04/2019.
//  Copyright © 2019 Self. All rights reserved.
//

import CoreLocation


// MARK: - View Model implementation
class LocationVM: NSObject {
    
    // MARK: - Private variables
    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.activityType = .fitness
        manager.desiredAccuracy = 200
        return manager
    }()
    
    
    // MARK: - Public Variables
    public var locationServicesEnabled: (()-> Void)?
    public var locationServicesDisabled: (()-> Void)?
}


// MARK: - Methods
extension LocationVM {
    
    // MARK: - Private
    private func checkLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationServicesEnabled?()
        default:
            locationServicesDisabled?()
        }
    }
    
    private func startMonitoring() {
        
    }
    
    
    // MARK: - Public
    func checkStatus() {
        locationManager.requestAlwaysAuthorization()
//        checkLocationServices()
    }
    
    func requestMonitoring() {
        startMonitoring()
    }
}


// MARK: - CLLocationManagerDelegate
extension LocationVM: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            locationServicesEnabled?()
        default:
            locationServicesDisabled?()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        
    }
}
