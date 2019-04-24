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
    enum Message: String {
        case userLocationUnavailable = "User location is not available. Please try again later."
    }
    
    // MARK: - IBOutlet
    @IBOutlet private weak var mapView: MKMapView!
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initCommon()
    }
    
    
    // MARK: - Actions
    @IBAction func actionTapOnUpdate(_ sender: Any) {
        let userLocation = mapView.userLocation.coordinate
        guard mapView.isUserLocationVisible else {
            showAlert(Message.userLocationUnavailable.rawValue)
            return
        }
        Geofence.shared.saveRegion(coordinate: userLocation)
        popToRoot()
    }
}


// MARK: - Setup
extension MapviewVC {
    
    func initCommon() {
        addLeftIcon(Icon.arrowBack)
        setTitle("Set Region")
        mapView.delegate = self
        
        guard let region = Geofence.shared.getCLRegion() else {
            return
        }
        showCircle(coordinate: region.center, radius: region.radius)
    }
    
    func setupMapView(location: CLLocationCoordinate2D) {
        let viewRegion = MKCoordinateRegion(center: location,
                                            latitudinalMeters: CLLocationDistance(Geofence.shared.getRadius()),
                                            longitudinalMeters: CLLocationDistance(Geofence.shared.getRadius()))
        mapView.setRegion(viewRegion, animated: true)
        mapView.showsUserLocation = true
    }
    
    func showCircle(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance) {
        let circle = MKCircle(center: coordinate, radius: radius)
        mapView.addOverlay(circle)
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
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.fillColor = Color.primary
        circleRenderer.alpha = 0.1
        return circleRenderer
    }
}
