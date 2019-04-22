//
//  ViewController.swift
//  Geofencing
//
//  Created by Abhishek Salokhe on 22/04/2019.
//  Copyright © 2019 Self. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initCommon()
    }
    
    override func onClickRightButtonItem() {
        guard let controller = getStoryboardVC(SettingsVC.identifier) else {
            return
        }
        pushVC(controller)
    }
}

extension ViewController {
    
    func initCommon() {
        addRightIcon(Icon.settings)
        setTitle("Geofencing")
    }
}
