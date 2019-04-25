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
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
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
        stopMonitoring()
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            locationServicesGeofenceUnavailable?()
            return
        }
        guard let region = Geofence.shared.getCLRegion() else { return }
        region.notifyOnEntry = true
        region.notifyOnExit = true
        locationManager.distanceFilter = CLLocationDistance(Geofence.shared.getRadius())
        locationManager.startMonitoring(for: region)
        locationManager.startUpdatingLocation()
        checkCurrentLocation(region)
    }
    
    private func checkCurrentLocation(_ circularRegion: CLCircularRegion?) {
        guard let region = circularRegion, let userLocation = locationManager.location else {
            return
        }
        print("Wifi", Utils.getConnectedWifiInfo())
        let location = CLLocation.init(latitude: region.center.latitude, longitude: region.center.longitude)
        if userLocation.distance(from: location) <= CLLocationDistance.init(Geofence.shared.getRadius()) {
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Updated location")
        if let region = Geofence.shared.getCLRegion() {
            checkCurrentLocation(region)
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
