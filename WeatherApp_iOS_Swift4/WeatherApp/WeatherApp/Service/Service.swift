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
    
    func fetchWeatherData(for city:String, completion: @escaping CompletionHandler) {
        guard let url = URL(string:WeatherData.endpoint(forCity: city)) else { fatalError("Could not create URL from components") }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil, let jsonData = responseData else {
                completion(.failure(stringError))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let codableWeatherData = try decoder.decode(CodableWeatherData.self, from: jsonData)
                let weatherData = ServiceUtility.convertToWeatherData(codableWeatherData)
                print("ljc - \(String(describing: weatherData))")
                completion(.success(weatherData))
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completion(.failure(stringError))
            }
        }
        task.resume()
    }
}
