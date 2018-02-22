//
//  ServiceUtility.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/6/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


class ServiceUtility: NSObject {
    class func convertToWeatherData(_ decodedWeatherData:CodableWeatherData) -> WeatherData {
        let title = decodedWeatherData.city.name
        let identifier = decodedWeatherData.city.id
        var items: [WeatherDataItem] = []
        for obj in decodedWeatherData.list {
            //time
            let time = obj.date
            let date = Date.init(timeIntervalSince1970: TimeInterval(time))
            let formatter = DateFormatter.init()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            // let dateString = formatter.string(from:date)
            // print("ljc - dateString:\(dateString)")
            // print("ljc Time:\(time.intValue/1000)")
            
            //dayOfWeek
            let dayOfWeek = AppUtility.returnDayOfWeekFromDate(date)
            
            //tempature
            let tempature = AppUtility.returnTempFromCurrentTime(obj.temp)
            
            //image id
             var imageId  = ""
            for icon in obj.weather {
                imageId = icon.icon
            }
            
            items.append(WeatherDataItem(imageId: imageId, tempature: tempature, dayOfWeek: dayOfWeek))
        }
        
        return WeatherData(identifier: identifier, title: title, items: items)
    }
}
