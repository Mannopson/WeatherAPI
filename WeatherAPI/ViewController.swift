//
//  ViewController.swift
//  WeatherAPI
//
//  Created by AzizOfficial on 7/17/21.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var degreeLabel: UILabel!
    
    let locationManager = CLLocationManager.init()
    let weatherModel = WeatherModel.shared
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.color = UIColor.systemTeal
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    lazy var activityView: UIView = {
        let screen = UIScreen.main
        let activityView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: screen.bounds.width, height: screen.bounds.height))
        activityView.backgroundColor = UIColor.systemBackground
        return activityView
    }()
    
    private func locationServices() {
        /* Set the delegate */
        locationManager.delegate = self
        
        /* Check service status */
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse: locationManager.requestLocation()
        case .notDetermined: locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted: self.error(title: "Access Denied")
        default: break
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.addSubview(activityView)
        activityIndicator.center = activityView.center
        activityView.addSubview(activityIndicator)
        
        degreeLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        cityNameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.rightBarButtonItem = unitsButton()
        
        locationServices()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            weatherModel.getConditionInfoByLocation(latitude: location.latitude, longitude: location.longitude, units: weatherModel.preferredUnits(), language: "en") { [weak self] (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async { [weak self] in
                        self?.activityView.removeFromSuperview()
                        self?.activityIndicator.stopAnimating()
                        
                        self?.iconImageView.image = self?.weatherModel.getSystemIcon(from: data.weather.last!.icon)
                        self?.cityNameLabel.text = data.name
                        self?.degreeLabel.text = Int.init(data.main.temp).description
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self?.error(title: error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.error(title: error.localizedDescription)
    }
}
