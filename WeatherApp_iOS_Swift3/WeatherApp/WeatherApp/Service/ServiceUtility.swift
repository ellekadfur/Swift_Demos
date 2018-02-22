//
//  ServiceUtility.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/6/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


class ServiceUtility: NSObject {
    class func convertToWeatherData(_ dictionary:[String: AnyObject]) -> WeatherData {
        let cityDict = dictionary[ServiceKeys.city.rawValue] as? [String: AnyObject] ?? [:]
        let title = cityDict[ServiceKeys.name.rawValue] as? String ?? ""
        let identifier = cityDict[ServiceKeys.id.rawValue] as? String ?? ""
        var items: [WeatherDataItem] = []
        
        let listDict = dictionary[ServiceKeys.list.rawValue] as? [[String: AnyObject]] ?? []
        //print("ljc - \(listDict)")
        for i in 0 ..< 6 {
            let obj: [String: AnyObject] = listDict[i]
            //print("ljc - \(obj)")
            //time
            let time = obj[ServiceKeys.dt.rawValue] as? NSNumber ?? NSNumber(value: 0)
            let date = Date.init(timeIntervalSince1970: TimeInterval(time.intValue))
            let formatter = DateFormatter.init()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            // let dateString = formatter.string(from:date)
            // print("ljc - dateString:\(dateString)")
            // print("ljc Time:\(time.intValue/1000)")
            
            //dayOfWeek
            let dayOfWeek = AppUtility.returnDayOfWeekFromDate(date)
            
            //tempature
            let tempDict = obj[ServiceKeys.temp.rawValue] as? [String : AnyObject] ?? [:]
            let tempature = AppUtility.returnTempFromCurrentTime(tempDict)
            
            //image id
            let globalImageArray = obj[ServiceKeys.weather.rawValue] as? [[String : AnyObject]]
            var imageId  = ""
            if let array = globalImageArray, array.count > 0 {
                let imageDict = array[0]
                imageId = imageDict[ServiceKeys.icon.rawValue] as? String ?? ""
            }
            items.append(WeatherDataItem(imageId: imageId, tempature: tempature, dayOfWeek: dayOfWeek))
        }
        
        return WeatherData(identifier: identifier, title: title, items: items)
    }
}
