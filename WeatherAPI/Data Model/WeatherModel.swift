//
//  WeatherModel.swift
//  WeatherAPI
//
//  Created by AzizOfficial on 7/17/21.
//

import Foundation
import UIKit

public struct WeatherCondition: Decodable {
    let weather: [Weather]
    let main: Main
    let name: String
}

public struct Weather: Decodable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

public struct Main: Decodable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

public struct ResponseError: Decodable, LocalizedError {
    let reason: String
    public var errorDescription: String? {
        return reason
    }
}

private enum Units: String {
    case imperial = "imperial"
    case metric = "metric"
}

class WeatherModel {
    static let shared = WeatherModel.init()
    
    public func snapshot() -> WeatherCondition {
        let weather = Weather.init(id: 1, main: "Sun", description: "Clear sky", icon: "10d")
        let main = Main.init(temp: 25, feels_like: 25.5, temp_min: 18.8, temp_max: 26.5, pressure: 5, humidity: 4)
        return WeatherCondition.init(weather: [weather], main: main, name: "Earth")
    }
    
    /*
     The API provider api.openweathermap.org website can be a provider of the icons too.
     */
    public func getAPIprovidedIcon(from string: String) -> UIImage? {
        return nil
    }
    
    public func getSystemIcon(from string: String) -> UIImage? {
        switch string {
        /* Day */
        case "01d": return UIImage.init(systemName: "sun.max.fill")
        case "02d": return UIImage.init(systemName: "cloud.sun.fill")
        case "03d": return UIImage.init(systemName: "cloud.fill")
        case "04d": return UIImage.init(systemName: "smoke.fill")
        case "09d": return UIImage.init(systemName: "cloud.heavyrain.fill")
        case "10d": return UIImage.init(systemName: "cloud.sun.rain.fill")
        case "11d": return UIImage.init(systemName: "cloud.bolt.fill")
        case "13d": return UIImage.init(systemName: "snow.fill")
        case "50d": return UIImage.init(systemName: "cloud.fog.fill")
        /* Night */
        case "01n": return UIImage.init(systemName: "moon.fill")
        case "02n": return UIImage.init(systemName: "cloud.moon.fill")
        case "03n": return UIImage.init(systemName: "cloud.fill")
        case "04n": return UIImage.init(systemName: "smoke.fill")
        case "09n": return UIImage.init(systemName: "cloud.heavyrain.fill")
        case "10n": return UIImage.init(systemName: "cloud.moon.rain.fill")
        case "11n": return UIImage.init(systemName: "cloud.bolt.fill")
        case "13n": return UIImage.init(systemName: "snow.fill")
        case "50n": return UIImage.init(systemName: "cloud.fog.fill")
        default: break
        }
        return nil
    }
    
    public func preferredUnits() -> String {
        if let userDefaults = UserDefaults.init(suiteName: "group.com.mannopson.weather_api"),
           let temperature_scales = userDefaults.object(forKey: "temperature_scales") as? Int {
            switch temperature_scales {
            case 0: return Units.metric.rawValue
            case 1: return Units.imperial.rawValue
            default: return Units.metric.rawValue
            }
        }
        return Units.metric.rawValue
    }
    
    public func getConditionInfoByLocation(latitude: Double,
                                           longitude: Double,
                                           units: String,
                                           language: String,
                                           completion: @escaping(Result<WeatherCondition, Error>) -> Void) {
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&units=\(units)&lang=\(language)&appid=104be51cdf577304ebb18c51e88bd721") {
            let task = URLSession.shared.dataTask(with: URLRequest.init(url: url)) { (data: Data?, response: URLResponse?, error: Error?) in
                
                if let error = error {
                    print("My error is: ", error.localizedDescription)
                    completion(.failure(error))
                    return
                }
               
                if let data = data {
                    do {
                        if let weather = try? JSONDecoder().decode(WeatherCondition.self, from: data) {
                            print("Response data: ", weather)
                            completion(.success(weather))
                        } else {
                            let responseError = try JSONDecoder().decode(ResponseError.self, from: data)
                            print("Response error: ", responseError)
                            completion(.failure(responseError))
                        }
                    } catch {
                        print(error.localizedDescription)
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        } else {
            // Bad URL... Error
        }
    }
}
