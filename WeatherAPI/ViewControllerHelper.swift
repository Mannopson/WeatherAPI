//
//  ViewControllerHelper.swift
//  WeatherAPI
//
//  Created by AzizOfficial on 7/19/21.
//

import Foundation
import UIKit

extension ViewController {
    public func error(title: String) {
        let alertController = UIAlertController.init(title: title, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction.init(title: "Ok", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func unitsMenu() -> UIMenu {
        let userDefaults = UserDefaults.standard
        let celsius = UIAction.init(title: "Celsius (°C)", image: nil) { _ in
            userDefaults.removeObject(forKey: "temperature_scales")
            userDefaults.set(0, forKey: "temperature_scales")
            self.navigationItem.rightBarButtonItem?.title = "°C"
            self.locationManager.requestLocation()
        }
        let fahrenheit = UIAction.init(title: "Fahrenheit (°F)", image: nil) { _ in
            userDefaults.removeObject(forKey: "temperature_scales")
            userDefaults.set(1, forKey: "temperature_scales")
            self.navigationItem.rightBarButtonItem?.title = "°F"
            self.locationManager.requestLocation()
        }
        return UIMenu.init(title: "Temperature Scales", options: .displayInline, children: [celsius, fahrenheit])
    }
    
    private func preferredTemperatureScale() -> String {
        if let userDefaults = UserDefaults.standard.object(forKey: "temperature_scales") as? Int {
            switch userDefaults {
            case 0: return "°C"
            case 1: return "°F"
            default: return "°C"
            }
        }
        return "°C"
    }
    
    public func unitsButton() -> UIBarButtonItem {
        return UIBarButtonItem.init(title: preferredTemperatureScale(), image: nil, primaryAction: nil, menu: unitsMenu())
    }
}
