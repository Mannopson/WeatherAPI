//
//  AppGroups.swift
//  WeatherAPI
//
//  Created by AzizOfficial on 7/25/21.
//

import Foundation

class AppGroups {
    static let shared = AppGroups.init()
    
    public func userDefaults(preferredTemp: Int) {
        if let userDefaults = UserDefaults.init(suiteName: "group.com.mannopson.weather_api") {
            userDefaults.removeObject(forKey: "temperature_scales")
            userDefaults.set(preferredTemp, forKey: "temperature_scales")
        }
    }
}
