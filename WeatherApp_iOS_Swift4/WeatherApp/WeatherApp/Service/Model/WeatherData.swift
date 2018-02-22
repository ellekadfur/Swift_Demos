//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/6/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


//MARK: - WeatherData
struct WeatherData: Encodable {
    let identifier: Int?
    let title: String?
    let items: [WeatherDataItem]?
    static func endpoint(forCity city:String) -> String {
        return "https://api.openweathermap.org/data/2.5/forecast/daily?q=\(city)&mode=json&units=metric&cnt=16&appid=adb4503a31093fed77c0a5f39d4c512b"
        //https://api.openweathermap.org/data/2.5/forecast/daily?q=Sunnyvale&mode=json&units=metric&cnt=16&appid=adb4503a31093fed77c0a5f39d4c512b
    }
    static func printJson(_ data:WeatherData) {
        let encoder = JSONEncoder()
//        encoder.outputFormatting = .compact
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(data)
            if let json = String(data: data, encoding: .utf8) {
                print(json)
                return
            }
            print("Error printing Encoded Json ")
        } catch {
            print("Error printing Encoded Json ")

        }
    }
}
struct WeatherDataItem: Encodable {
    let imageId: String?
    let tempature: String?
    let dayOfWeek: String?
}

//MARK: - CodableWeatherData
struct CodableWeatherData: Codable {
    let city: City
    let list: [List]
}
struct City: Codable {
    let name: String
    let id: Int
}
struct List: Codable {
    let date: Int
    let temp: Temp
    let weather: [Weather]
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temp = "temp"
        case weather = "weather"
    }
}
struct Weather: Codable {
    let icon: String
}
struct Temp: Codable {
    let day: Double
    let night: Double
    let morn: Double
}
