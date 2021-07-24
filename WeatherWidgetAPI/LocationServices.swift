//
//  LocationServices.swift
//  WeatherWidgetAPIExtension
//
//  Created by AzizOfficial on 7/24/21.
//

import Foundation
import CoreLocation

class LocationServices: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager.init()
    private var userLocation: ((Result<CLLocation, Error>) -> Void)?
    
    override init() {
        super.init()
        print("Initialized")
        locationManager.delegate = self
        
        if locationManager.isAuthorizedForWidgetUpdates {
            locationManager.requestLocation()
        }
    }
    
    func fetchLocation(completion: @escaping ((Result<CLLocation, Error>) -> Void)) {
        userLocation = completion
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            if let userLocation = userLocation {
                userLocation(.success(location))
            }
            print("Delegate", location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let userLocation = userLocation {
            userLocation(.failure(error))
        }
        print(error.localizedDescription)
    }
}
