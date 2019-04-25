//
//  Global.swift
//  Geofencing
//
//  Created by Abhishek Salokhe on 22/04/2019.
//  Copyright © 2019 Self. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

enum Icon {
    static let settings = #imageLiteral(resourceName: "ic_settings")
    static let arrowBack = #imageLiteral(resourceName: "ic_arrow_back")
}

enum Color {
    static let primary = UIColor.init(red: 55/255.0, green: 63/255.0, blue: 69/255.0, alpha: 1.0)
    static let secondary = UIColor.init(red: 239/255.0, green: 239/255.0, blue: 239/255.0, alpha: 1.0)
}

class Utils {
    
    //SO
    struct NetworkInfo {
        public let interface:String
        public let ssid:String
        public let bssid:String
        init(_ interface:String, _ ssid:String,_ bssid:String) {
            self.interface = interface
            self.ssid = ssid
            self.bssid = bssid
        }
    }
    
    //TODO: Not able to perform this as Access WIFI Information capability
    //not available in free developer account!
    class func getConnectedWifiInfo() -> Array<NetworkInfo> {
        guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
            return []
        }
        let networkInfos:[NetworkInfo] = interfaceNames.compactMap{ name in
            guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
                return nil
            }
            guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
                return nil
            }
            guard let bssid = info[kCNNetworkInfoKeyBSSID as String] as? String else {
                return nil
            }
            return NetworkInfo(name, ssid,bssid)
        }
        return networkInfos
    }
}
