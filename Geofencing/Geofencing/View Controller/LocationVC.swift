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
    private var messagePrefix = "Location services are disabled! Click on"
    private var messageSuffix = "button below to request."
    
    
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
        viewModel.checkStatus()
    }
    
    
    // MARK: - Actions
    override func onClickRightButtonItem() {
        pushVC(SettingsVC.identifier)
    }
    
    @IBAction func actionTapOnAuthorize(_ sender: UIButton) {
        if sender.tag == -2 {
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        } else {
            viewModel.checkStatus()
        }
    }
}


// MARK: - Initial Setup
extension LocationVC {
    
    func initCommon() {
        setTitle("Geofencing")
    }
    
    func updateMessage() {
        labelMessage.text = "\(messagePrefix) `\(buttonStatus.titleLabel?.text ?? "-")` \(messageSuffix)"
    }
}


// MARK: - Location Binding
extension LocationVC {
 
    func initBinding() {
        
        viewModel.locationServicesEnabled = { [weak self] in
            self?.viewModel.requestMonitoring()
            self?.viewStatus.isHidden = false
            self?.viewMain.isHidden = true
            self?.addRightIcon(Icon.settings)
        }
        
        viewModel.locationServicesDisabled = { [weak self] in
            self?.viewStatus.isHidden = true
            self?.viewMain.isHidden = false
            self?.setButtonTitle("Settings")
            self?.buttonStatus.tag = -2
        }
    }
    
    func setButtonTitle(_ title: String) {
        buttonStatus.setTitle(title, for: .normal)
        updateMessage()
    }
}
