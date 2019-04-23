//
//  DefaultsHelper.swift
//  Geofencing
//
//  Created by Abhishek Salokhe on 23/04/2019.
//  Copyright © 2019 Self. All rights reserved.
//

import Foundation

enum DefaultsKey: String {
    case latitude = "latitude"
    case longitude = "longitude"
    case radius = "radius"
}

class DefaultsHelper {
    
    private static let defaults = UserDefaults.standard
    
    public static func saveValue(_ value: Any, _ key: DefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    public static func getValue(_ key: DefaultsKey) -> Any? {
        return defaults.value(forKey: key.rawValue)
    }
}
