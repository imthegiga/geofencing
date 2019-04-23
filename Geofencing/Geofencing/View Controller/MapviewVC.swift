//
//  MapviewVC.swift
//  Geofencing
//
//  Created by Abhishek Salokhe on 23/04/2019.
//  Copyright © 2019 Self. All rights reserved.
//

import UIKit

class MapviewVC: UIViewController {

    static let identifier = "MapviewVC"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initCommon()
    }
}

extension MapviewVC {
    
    func initCommon() {
        addLeftIcon(Icon.arrowBack)
        setTitle("Set Region")
    }
}
