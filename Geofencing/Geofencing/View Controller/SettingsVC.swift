//
//  SettingsVC.swift
//  Geofencing
//
//  Created by Abhishek Salokhe on 22/04/2019.
//  Copyright © 2019 Self. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {

    // MARK: - Variables
    static let identifier = "SettingsVC"
    @IBOutlet weak var labelRadiusValue: UILabel!
    @IBOutlet weak var radiusSlider: UISlider!
    
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initCommon()
    }
    
    
    // MARK: - Actions
    @IBAction func actionTapSetRegion(_ sender: Any) {
        pushVC(MapviewVC.identifier)
    }
    
    @IBAction func actionSlideRadiusValue(_ sender: UISlider) {
        //This one increments in 5 instead of default 1
        let roundedValue = round(sender.value / 5) * 5
        sender.value = roundedValue
        
        DefaultsHelper.saveValue(Int(sender.value), .radius)
        updateRadiusLabel()
    }
}


// MARK: - Initial Setup
extension SettingsVC {
    
    func initCommon() {
        addLeftIcon(Icon.arrowBack)
        setTitle("Settings")
        radiusSlider.value = Float(Geofence.shared.getRadius())
        updateRadiusLabel()
    }
    
    func updateRadiusLabel() {
        labelRadiusValue.text = "\(Int(radiusSlider.value))m"
    }
}
