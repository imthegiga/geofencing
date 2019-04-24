//
//  LocationVC.swift
//  Geofencing
//
//  Created by Abhishek Salokhe on 22/04/2019.
//  Copyright © 2019 Self. All rights reserved.
//

import UIKit
import CoreLocation

class LocationVC: UIViewController {
    
    // MARK: - Variables
    private let viewModel = LocationVM()
    enum Message: String {
        case messageRequest = "Location services are disabled! Click on `Authorize` button below to request."
        case messageEnable = "Enable location services by clicking `Settings` button below."
        case deviceInsideGeofence = "This device is inside geofence area"
        case deviceOutsideGeofence = "This device is outside geofence area"
        case monitorTitle = "The device will monitor its location and keep updating the status below"
        case geofenceRegionNeeded = "Set region from ⚙︎ to monitor"
        case geofenceMonitorStart = "This device started monitoring geofence area"
        case geofenceUnavailable = "The device does not support geofencing"
    }
    
    
    // MARK: - IBOutlet
    @IBOutlet private weak var labelMessage: UILabel!
    @IBOutlet private weak var buttonStatus: UIButton!
    @IBOutlet private weak var viewMain: UIView!
    @IBOutlet private weak var viewStatus: UIView!
    @IBOutlet private weak var labelStatus: UILabel!
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initCommon()
        initBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trackStatus()
    }
    
    
    // MARK: - Actions
    override func onClickRightButtonItem() {
        pushVC(SettingsVC.identifier)
    }
    
    @IBAction func actionTapOnAuthorize(_ sender: UIButton) {
        if sender.tag == -2 {
            openAppSettings()
        } else {
            viewModel.requestAuthorization()
        }
    }
}


// MARK: - Initial Setup
extension LocationVC {
    
    func initCommon() {
        setTitle("Geofencing")
        NotificationCenter.default.addObserver(self, selector: #selector(trackStatus), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    @objc func trackStatus() {
        viewModel.checkStatus()
    }
    
    func updateMessage(_ message: Message) {
        labelMessage.text = message.rawValue
    }
    
    func updateStatus(_ status: Message) {
        labelStatus.text = status.rawValue
    }
}


// MARK: - Location Binding
extension LocationVC {
 
    func initBinding() {
        
        viewModel.locationServicesEnabled = { [weak self] in
            self?.checkRegionSet()
            self?.showEnabledView()
        }
        
        viewModel.locationServicesDisabled = { [weak self] in
            self?.showDisabledView()
        }
        
        viewModel.locationServicesNotDetermined = { [weak self] in
            self?.showNotDeterminedView()
        }
        
        viewModel.locationServicesEnteredRegion = { [weak self] (address) in
            self?.updateStatus(.deviceInsideGeofence)
            self?.labelStatus.text?.append(" \(address)")
        }
        
        viewModel.locationServicesExitedRegion = { [weak self] (address) in
            self?.updateStatus(.deviceOutsideGeofence)
            self?.labelStatus.text?.append(" \(address)")
        }
        
        viewModel.locationServicesGeofenceUnavailable = { [weak self] in
            self?.updateStatus(.geofenceUnavailable)
        }
    }
    
    func setButtonTitle(_ title: String, _ message: Message) {
        buttonStatus.setTitle(title, for: .normal)
        updateMessage(message)
    }
    
    func checkRegionSet() {
        if !Geofence.shared.isRegionAvailable() {
            updateStatus(.geofenceRegionNeeded)
        } else {
            updateStatus(.geofenceMonitorStart)
        }
    }
    
    func showEnabledView() {
        viewModel.enableMonitoring()
        viewStatus.isHidden = false
        viewMain.isHidden = true
        addRightIcon(Icon.settings)
    }
    
    func showDisabledView() {
        viewStatus.isHidden = true
        viewMain.isHidden = false
        setButtonTitle("Settings", .messageEnable)
        buttonStatus.tag = -2
    }
    
    func showNotDeterminedView() {
        viewStatus.isHidden = true
        viewMain.isHidden = false
        setButtonTitle("Authorize", .messageRequest)
        buttonStatus.tag = -1
    }
}
