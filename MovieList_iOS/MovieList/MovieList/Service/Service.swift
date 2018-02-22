//
//  Service.swift
//  MovieList
//
//  Created by Lamar Jay Caaddfiir on 2/18/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


enum Result<Value> {
    case success(Value)
    case failure(String)
}

typealias CompletionHandler = ((Result<[MovieData]>) -> ())

let stringError = "Please check your Network Connection."

class Service: NSObject {
    
    func fetchMovieData(completion: @escaping CompletionHandler) {
        guard let url = URL(string:MovieData.endpoint()) else { completion(.failure(stringError)); return }
        
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
                     print("ljc - \(String(describing: json))")
                    let movieData = ServiceUtility.convertToMovieData(json)
                    completion(.success(movieData))
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
