//
//  Geofence.swift
//  Geofencing
//
//  Created by Abhishek Salokhe on 22/04/2019.
//  Copyright © 2019 Self. All rights reserved.
//

import CoreLocation.CLRegion

class Geofence {
    
    public let identifier = "geofence-area"
    
    public static let shared = Geofence()
    
    private init() { }
    
    func getCLRegion() -> CLCircularRegion? {
        
        guard
            let lat = DefaultsHelper.getValue(.latitude) as? Double,
            let lng = DefaultsHelper.getValue(.longitude) as? Double
            else { return nil }
        
        let radiusInMeters = getRadius()
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        return CLCircularRegion.init(center: coordinate,
                                     radius: CLLocationDistance(radiusInMeters),
                                     identifier: identifier)
    }
    
    func isRegionAvailable() -> Bool {
        return (DefaultsHelper.getValue(.latitude) as? Double != nil) &&
            (DefaultsHelper.getValue(.longitude) as? Double != nil)
    }
    
    func saveRegion(coordinate: CLLocationCoordinate2D) {
        DefaultsHelper.saveValue(coordinate.latitude, .latitude)
        DefaultsHelper.saveValue(coordinate.longitude, .longitude)
    }
    
    func saveRadius(radius: Int) {
        DefaultsHelper.saveValue(radius, .radius)
    }
    
    func getRadius() -> Int {
        return DefaultsHelper.getValue(.radius) as? Int ?? 300 //defaults to 300 meters
    }
}
