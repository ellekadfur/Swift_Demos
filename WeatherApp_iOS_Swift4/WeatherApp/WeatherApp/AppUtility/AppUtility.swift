//
//  AppUtility.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/18/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//

import Foundation

class AppUtility: NSObject {
    class func returnDayOfWeekFromDate(_ date: Date) -> String {
        
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "hh a EEEE"
        let str = formatter.string(from:date)
        
        let array = str.components(separatedBy: " ")
        var dayOfWeek = "";
        if (array.count>2) {
            dayOfWeek = array[2];
        }
        else if (array.count>1) {
            dayOfWeek = array[1];
        }
        if !dayOfWeek.isEmpty {
            return dayOfWeek
        }
        return "Error";
    }
    
    class func returnTempFromCurrentTime(_ temp: Temp) -> String {
        let date = Date.init()
        let formatter = DateFormatter.init()
        formatter.dateFormat = "hh a EEEE"
        let str = formatter.string(from:date)
        let array = str.components(separatedBy: " ")
        var timeInHour: String = ""
        var am_pm = ""
        if (array.count>2) {
            timeInHour = array[0];
            am_pm = array[1];
        }
        else if (array.count>1) {
            timeInHour = array[0];
        }
        
        guard let theTime = Int(timeInHour) else { return "Error" }
        if !am_pm.isEmpty {
            if theTime >= 4 && theTime <= 9 && am_pm == "AM" {
                //Morning
                    return AppUtility.convertCelsiusToFarhient(temp.morn)
            }
            else if ((theTime) >= 10 && theTime != 12 && am_pm == "AM") || ((theTime < 4 || theTime == 12) && am_pm == "PM") {
                //Afternoon
                    return AppUtility.convertCelsiusToFarhient(temp.day)
            }
            else if (theTime >= 4 && theTime <= 9 && am_pm == "PM") {
                //Evening
                    return AppUtility.convertCelsiusToFarhient(temp.night)
            }
            else if ((theTime >= 10 && theTime != 12 && am_pm == "PM") || ((theTime < 4 || theTime == 12) && am_pm == "AM")) {
                //Night
                    return AppUtility.convertCelsiusToFarhient(temp.night)
            }
        }
        else {
            if (theTime >= 4 && theTime < 10) {
                //Morning
                    return AppUtility.convertCelsiusToFarhient(temp.morn)
            }
            else if (theTime >= 10 && theTime < 16) {
                //Afternoon
                    return AppUtility.convertCelsiusToFarhient(temp.day)
            }
            else if theTime >= 16 && theTime < 22 {
                //Evening
                    return AppUtility.convertCelsiusToFarhient(temp.night)
            }
            else {
                //Night
                    return AppUtility.convertCelsiusToFarhient(temp.night)
            }
        }
        return "Error";
    }
    
    class func convertCelsiusToFarhient(_ celsius:Double) -> String {
        return NSNumber.init(value:(Int.init(celsius * 1.8) + 32)).stringValue
    }
}
