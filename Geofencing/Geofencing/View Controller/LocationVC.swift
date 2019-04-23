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
    
    // MARK: - IBOutlet
    @IBOutlet private weak var viewStatus: UIView!
    @IBOutlet private weak var labelStatus: UILabel!
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initCommon()
        initBinding()
    }
    
    
    // MARK: - Actions
    override func onClickRightButtonItem() {
        pushVC(SettingsVC.identifier)
    }
    
    @IBAction func actionTapOnAuthorize(_ sender: Any) {
        viewModel.checkStatus()
    }
}


// MARK: - Initial Setup
extension LocationVC {
    
    func initCommon() {
        addRightIcon(Icon.settings)
        setTitle("Geofencing")
    }
}


// MARK: - Location Binding
extension LocationVC {
 
    func initBinding() {
        
        viewModel.locationServicesEnabled = { [weak self] in
            self?.viewModel.requestMonitoring()
        }
        
        viewModel.locationServicesDisabled = {
            
        }
    }
}
