//
//  Service.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/6/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


enum Result<Value> {
    case success(Value)
    case failure(String)
}

typealias CompletionHandler = ((Result<WeatherData>) -> ())

let stringError = "Please check your Network Connection."

class Service: NSObject {
    private let appId = "adb4503a31093fed77c0a5f39d4c512b"
    
    func endpoint(forCity city:String) -> String {
        return "https://api.openweathermap.org/data/2.5/forecast/daily?q=\(city)&mode=json&units=metric&cnt=16&appid=\(appId)"
    }
    
    func fetchWeatherData(for city:String, completion: @escaping CompletionHandler) {
        guard let url = URL(string:self.endpoint(forCity: city)) else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil, let jsonData = responseData else {
                completion(.failure(stringError))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: jsonData) as? [String: AnyObject] {
                    // print("ljc - \(String(describing: json))")
                    let weatherData = ServiceUtility.convertToWeatherData(json)
                    completion(.success(weatherData))
                }
                else {
                    completion(.failure(stringError))
                }
            } catch {
                // print("Error deserializing JSON: \(error)")
                completion(.failure(stringError))
            }
        }
        task.resume()
    }
}
