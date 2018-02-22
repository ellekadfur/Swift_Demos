//
//  ImageDownloader.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/7/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


typealias ImageCompletionHandler = (Result<UIImage>) -> Void


class ImageDownloader: NSObject {
    /*
     class var sharedInstance: ImageDownloader {
     struct Static {
     static var instance: ImageDownloader?
     static var token = {0}()
     }
     _ = Static.token
     return Static.instance!
     }
     */
    //static let sharedInstance: ImageDownloader = { ImageDownloader() }()
    
    class func fetchImageUrl(for imageId:String, completion: @escaping ImageCompletionHandler) {
         let completeImageURL = "https://openweathermap.org/img/w/ID.png"
         let patternString = "ID"
        
        guard let url = URL(string:completeImageURL.replacingOccurrences(of: patternString, with: imageId)) else { fatalError("Could not create URL from components") }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        session.downloadTask(with: url) { (urlImage, urlResponse, error) in
            if error != nil {
                 completion(.failure("image Error"))
            }
            else {
                if let urlImage = urlImage {
                    do {
                        let imageData = try Data.init(contentsOf: urlImage)
                        if let image = UIImage.init(data: imageData) {
                            completion(.success(image))
                        }
                        else {
                             completion(.failure("image Error"))
                        }
                    } catch {
                         completion(.failure("image Error"))
                    }
                }
                else {
                     completion(.failure("image Error"))
                }
            }
            }.resume()
    }
}
