//
//  MapviewVC.swift
//  Geofencing
//
//  Created by Abhishek Salokhe on 23/04/2019.
//  Copyright © 2019 Self. All rights reserved.
//

import UIKit
import MapKit

class MapviewVC: UIViewController {

    
    // MARK: - Variable
    static let identifier = "MapviewVC"
    
    
    // MARK: - IBOutlet
    @IBOutlet private weak var mapView: MKMapView!
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initCommon()
    }
}


// MARK: - Setup
extension MapviewVC {
    
    func initCommon() {
        addLeftIcon(Icon.arrowBack)
        setTitle("Set Region")
        mapView.delegate = self
    }
    
    func setupMapView(location: CLLocationCoordinate2D) {
        let viewRegion = MKCoordinateRegion(center: location,
                                            latitudinalMeters: 200,
                                            longitudinalMeters: 200)
        mapView.setRegion(viewRegion, animated: true)
        mapView.showsUserLocation = true
    }
}


// MARK: - MKMapViewDelegate
extension MapviewVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        addRightIndicator()
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        removeRightBarButtonItem()
    }
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        setupMapView(location: userLocation.coordinate)
    }
}
