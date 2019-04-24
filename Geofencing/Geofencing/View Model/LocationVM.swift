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
        manager.activityType = .otherNavigation
        manager.desiredAccuracy = 200
        manager.allowsBackgroundLocationUpdates = true
        return manager
    }()
    
    
    // MARK: - Public Variables
    public var locationServicesEnabled: (()-> Void)?
    public var locationServicesDisabled: (()-> Void)?
    public var locationServicesNotDetermined: (() -> Void)?
    public var locationServicesEnteredRegion: ((String) -> Void)?
    public var locationServicesExitedRegion: ((String) -> Void)?
    public var locationServicesGeofenceUnavailable: (() -> Void)?
}


// MARK: - Methods
extension LocationVM {
    
    // MARK: - Private
    private func checkLocationServices() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationServicesNotDetermined?()
        case .authorizedAlways, .authorizedWhenInUse:
            locationServicesEnabled?()
        default:
            locationServicesDisabled?()
        }
    }
    
    private func startMonitoring() {
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            locationServicesGeofenceUnavailable?()
            return
        }
        guard let region = Geofence.shared.getCLRegion() else { return }
        region.notifyOnEntry = true
        region.notifyOnExit = true
        stopMonitoring()
        locationManager.startMonitoring(for: region)
        checkCurrentLocation(region)
    }
    
    private func checkCurrentLocation(_ circularRegion: CLCircularRegion?) {
        guard let region = circularRegion, let userLocation = locationManager.location else {
            return
        }
        let location = CLLocation.init(latitude: region.center.latitude, longitude: region.center.longitude)
        if userLocation.distance(from: location) <= location.altitude {
            CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                self.locationServicesEnteredRegion?((placemark ?? []).first?.locality ?? "")
            }
        } else {
            CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                self.locationServicesExitedRegion?((placemark ?? []).first?.locality ?? "")
            }
        }
    }
    
    private func stopMonitoring() {
        for region in locationManager.monitoredRegions {
            locationManager.stopMonitoring(for: region)
        }
    }
    
    
    // MARK: - Public
    @objc func checkStatus() {
        checkLocationServices()
    }
    
    func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func enableMonitoring() {
        startMonitoring()
    }
    
    func disableMonitoring() {
        stopMonitoring()
    }
}


// MARK: - CLLocationManagerDelegate
extension LocationVM: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationServicesNotDetermined?()
        case .authorizedAlways, .authorizedWhenInUse:
            locationServicesEnabled?()
        default:
            locationServicesDisabled?()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("Entered region", region.identifier)
        if let circularRegion = region as? CLCircularRegion {
            let location = CLLocation.init(latitude: circularRegion.center.latitude, longitude: circularRegion.center.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                self.locationServicesEnteredRegion?((placemark ?? []).first?.locality ?? "")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("Exited region", region.identifier)
        if let circularRegion = region as? CLCircularRegion {
            let location = CLLocation.init(latitude: circularRegion.center.latitude, longitude: circularRegion.center.longitude)
            CLGeocoder().reverseGeocodeLocation(location) { (placemark, error) in
                self.locationServicesExitedRegion?((placemark ?? []).first?.locality ?? "")
            }
        }
    }
}
