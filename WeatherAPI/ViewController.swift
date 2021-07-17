//
//  ViewController.swift
//  WeatherAPI
//
//  Created by AzizOfficial on 7/17/21.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView.init(style: .large)
        activityIndicator.color = UIColor.white
        activityIndicator.startAnimating()
        return activityIndicator
    }()
    
    lazy var activityView: UIView = {
        let activityView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        activityView.backgroundColor = UIColor.systemTeal
        return activityView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.addSubview(activityView)
        activityIndicator.center = activityView.center
        activityView.addSubview(activityIndicator)
    }
}

