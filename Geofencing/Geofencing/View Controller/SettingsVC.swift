//
//  SettingsVC.swift
//  Geofencing
//
//  Created by Abhishek Salokhe on 22/04/2019.
//  Copyright © 2019 Self. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    static let identifier = "SettingsVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initCommon()
    }
    
    @IBAction func actionTapSetRegion(_ sender: Any) {
        pushVC(MapviewVC.identifier)
    }
    
    @IBAction func actionTapSetRadius(_ sender: Any) {
    }
}

extension SettingsVC {
    
    func initCommon() {
        addLeftIcon(Icon.arrowBack)
        setTitle("Settings")
    }
}
